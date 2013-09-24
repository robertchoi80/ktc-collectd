#!/usr/bin/env ruby

require 'socket'
require 'syslog'

# Access to collectd data using the unix socket
# interface

# Jason K Jackson <jasonjackson@gmail.com>

# ./splunk.rb 20.0.1.155 4110

class Splunk
  def initialize()
    @host = ARGV[0]
    @port = ARGV[1].to_i
    protocol = "udp"

    @hostname = Socket.gethostbyname(Socket.gethostname).first

    @splunk_sock = UDPSocket.open
  end

  def send_data(metric_time, data)

    #puts metric_time.to_s
    #puts data.instance_of? String
    #list_data = data.split("\n")
    #puts list_data.instance_of? Array

    #if protocol == "tcp"
    #  splunk_sock = TCPSocket.open(host, port)
    #  splunk_sock.write(data)
    #  splunk_sock.close()
    #else
    #  splunk_sock = UDPSocket.open
    #  list_data.each do |d|
    #    splunk_sock.send("collectd: " + d + "\n", 0, host, port)
    #  end
    #  splunk_sock.close()
    #end

    message = metric_time.to_s + " " + @hostname + " collectd: " + data
    @splunk_sock.send(message, 0, @host, @port)
  end

  def close_sock()
    @splunk_sock.close()
  end

end

class Collectd
  include Socket::Constants

  # initializes the collectd interface
  # path is the location of the collectd
  # unix socket
  #
  # collectd = Collectd.new
  #
  def initialize(path="/var/lib/collectd/collectd.sock")
    @socket = UNIXSocket.open(path)
    # @socket = Socket.new(AF_UNIX, SOCK_STREAM, 0)
    # @socket.connect(path)
    @path = path
  end

  # iterates over available values, passing the
  # identifier to the block and the time
  # the data for this identifier was last
  # updated
  #
  # collectd.each_value do |time, identifier|
  #   ...
  # end
  def each_value
    n_lines = cmd("LISTVAL")
    n_lines.times do
      line = @socket.readline
      time_s, identifier = line.split(' ', 2)
      time = Time.at(time_s.to_i)
      yield time, identifier
    end
  end

  # iterates over each value current data
  #
  # collectd.each_value_data('myhost/swap/swap-free') { |col, val| }
  #
  # each iteration gives the column name and the value for it.
  #
  # You can also disable flushing by specifying it as an option:
  #
  # client.each_value_data('myhost/swap/swap-free',
  #                   :flush => false ) do |col, val|
  #    # .. do something with col and val
  # end
  #
  # :flush option is by default true
  #
  def each_value_data(identifier, opts={})
    n_lines = cmd("GETVAL \"#{identifier}\"")
    n_lines.times do
      line = @socket.readline
      col, val = line.split('=', 2)
      yield col, val
    end

    # unless the user explicitly disabled
    # flush...
    unless opts[:flush] == false
      cmd("FLUSH identifier=\"#{identifier}\"")
    end
    
  end
  
  private
  
  # internal command execution
  def cmd(c)
    @socket.write("#{c}\n")
    line = @socket.readline
    status_string, message = line.split(' ', 2)
    status = status_string.to_i
    raise message if status < 0
    status  
  end
  
end

if __FILE__ == $0

#  Example usage of the above class methods:
#
#  client = Collectd.new
#  client.each_value do |time, id|
#    puts "#{time.to_i} - #{id}"
#  end
#
#  client.each_value_data("chef-dev-vm.epc-dev.ucloud.com/cpu-0/cpu-user") do |col, val|
#    puts "#{col} -> #{val}"
#  end
#  
  client = Collectd.new
  splunk = Splunk.new
  
  metric_time = ""
  collectd_array = []
  client.each_value do |time, id|
    collectd_array << id.chomp
    metric_time = time
  end
  
  @check_hash = {}
  
  collectd_array.each do |id|
    id_array = id.split('/')
    @host = id_array[0].chomp
    @check = id_array[1].chomp
    @item = id_array[2].chomp
    
    check_class = @check[/[\w]+/]
    
    if @host =~ /^instance-/
      next
    end

    @check_hash[@host] = {} unless @check_hash.has_key?(@host)
    @check_hash[@host][@check] = {} unless @check_hash[@host].has_key?(@check)
    
    
    client.each_value_data(id.chomp) do |col, val|
      if col == "value"
        @check_hash[@host][@check][@item] = ("%.8f" % val.chomp).to_f unless val == "NaN\n"
      else
        @check_hash[@host][@check][@item] = {} unless @check_hash[@host][@check].has_key?(@item)
        @check_hash[@host][@check][@item][col] = ("%.8f" % val.chomp).to_f unless val == "NaN\n"
      end
    end
  end

  @check_hash.each do |host, metrics|
    metrics.each do |type, check|
      @logstr = "chost=#{host} ccheck=#{type}"
      
      # redmine ticket #3422
      if type =~ /^cpufreq|^disk|^interface|^irq|^processes|^vmem|^mysql/
        next
      end

      if type == 'exec-nexenta1'   # Need a different format for snodes
        @logstr = "chost=#{host} ccheck=#{type}"
        check.each do |k,v|
          @storelog = String.new
          v.each do |i,j|
            @storelog << " #{i}=#{j}"
          end
          #Syslog.open("collectd:", Syslog::LOG_PID, Syslog::LOG_LOCAL5) { |s| s.info "chost=#{host} ccheck=#{type} #{k} #{@storelog}" }
	  splunk.send_data("chost=#{host} ccheck=#{type} #{k} #{@storelog}")
        end
      else
        check.each do |k,v|
          if v.is_a?(Hash)
            v.each do |j,i|
              @logstr << " #{k}-#{j}=#{i}"
            end
          else
            @logstr << " #{k}=#{v}"
          end
        end
      end
      #Syslog.open("collectd:", Syslog::LOG_PID, Syslog::LOG_LOCAL5) { |s| s.info @logstr }
      splunk.send_data(metric_time, @logstr)
    end
  end
  splunk.close_sock()
end
