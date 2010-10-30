# = UNIX rsh(1) wrapper class
# 
# Creates and operates an 'rsh' command call instance. Parameters to rsh may
# be specified through either constructor or attribute accessors. Result of
# rsh execution (_String_) is either returned in functional style (<tt>execute!</tt> method call)
# or in special attribute, _result_.
#
# == Synopsis
#
#   require 'rsh'
#
#   rsh = Rsh.new(:host => "c7206", :ruser => "bill",
#                 :command => "show clock")
#
#   rsh.execute! do |line| puts line end
#
#   18:30:46.799 MSD Fri Oct 22 2010
#
# * See c) case in execute! method comment. 
#
# === Example:
#
# This is an example of rsh in action usin interactive Ruby.
#
#   irb(main):001:0> require 'rsh'
#   => true
#
#   irb(main):002:0> rsh = Rsh.new(:host => "c7206", :ruser => "bill",
#                                  :command => "show clock")
#   => #<Rsh:0x2853f390 @ruser="bill", @executable="/usr/bin/rsh", @result="", @command="show clock", @nullr=false, @host="c7206", @to=3>
#
#   irb(main):003:0> rsh.execute! do |line| puts line end
#
#   18:30:46.799 MSD Fri Oct 22 2010
#   => "\r\n18:30:46.799 MSD Fri Oct 22 2010\n"
#
#
# == See also
#
#   % man 1 rsh
#
class Rsh
  require 'socket'
  # flags whether to force pure ruby rsh client
  attr_accessor :ruby_impl
  # Local user name, used in pure ruby implementation.
  attr_accessor :luser
  # path to rsh program, +String+
  attr_reader   :executable
  # result +String+
  attr_reader   :result
  # remote server hostname or IP, +String+
  attr_accessor :host
  # remote command, +String+
  attr_accessor :command
  # remote username, +String+
  attr_accessor :ruser
  # rsh timeout, +Integer+ (see man 1 rsh)
  attr_accessor :to

  # boolean knob for <tt>/dev/null</tt> redirection; see man rsh for further
  # information
  attr_accessor :nullr

  # The Constructor. If :ruby_impl is false checks the presence of rsh in the system (running,
  # naturally, 'which rsh') and prepares the command to be run with <tt>execute!</tt>. 
  # rsh CLI arguments are either having default values, being collected from constructor 
  # call or specified via accessors.
  #
  # Call sequence:
  #   Rsh.new -> Rsh instance
  #   Rsh.new(:host      => "hostname",
  #           :command   => "example.sh",
  #           :ruser     => "jack",
  #           :to        => 5,
  #           :nullr     => true
  #           :ruby_impl => true) -> Rsh instance
  # 
  # If called without arguments, the following default values are being used:
  # 
  #   :host      => "localhost"
  #   :command   => ""
  #   :ruser     => "nobody"
  #   :to        => 3
  #   :nullr     => false
  #   :ruby_impl => false
  #
  def initialize(args={})
    args = {
      :host      => "localhost",
      :command   => "",
      :ruser     => "nobody",
      :luser     => ENV["USER"] || "nobody",
      :to        => 3,
      :nullr     => false,
      :ruby_impl => false
    }.merge!(args)

    @result     = ""
    @ruby_impl  = args[:ruby_impl]
    @host       = args[:host]
    @command    = args[:command]
    @ruser      = args[:ruser]
    @to         = args[:to]
    @nullr      = args[:nullr]

    unless @ruby_impl
      begin
        open("| which rsh") do |io|
          @executable = io.gets.chomp
        end
      rescue => detail
        @ruby_impl = true
      end
    end
  end

  # Executes rsh command using previously collected arguments. If :ruby_impl is
  # true or system rsh binary was not found during initialize runs pure ruby rsh
  # client.
  #
  # If given a block, calls it for each line received from rsh output
  # (parameter _line_).
  #
  # Call sequence:
  #
  # a)
  #   rsh_inst.execute! do |line|
  #     puts line
  #   done #=> complete_result_String
  # b)
  #   rsh_inst.execute! #=> complete_result_String
  # c)
  #   rsh_inst.execute! "remote_command" #=> same as above, but replacing
  #                                          @command with the given string
  #
  # Returns:: the complete rsh output as one _String_. The result is also
  #           stored and available via _result_ attribute.
  #
  def execute!(command=nil)
    @command = command if command
    @result = ""
    if @ruby_impl
      # pure ruby implementation call
      rsh_ruby do |line|
        yield(line) if block_given?
        @result << line
      end
    else
      # OS'es rsh(1) call
      open "|#{@executable} #{"-n" if @nullr} -l#{@ruser} -t#{@to} #{@host} #{@command}" do |io|
        io.each do |line|
          yield(line) if block_given?
          @result << line
        end
      end
    end
    @result
  end

  private
  # pure ruby rsh client
  def rsh_ruby
    r = ""
    s = TCPSocket.new(@host, 514)
    s.write "0\0"
    s.write "#{@luser}\0"
    s.write "#{@ruser}\0"
    s.write "#{@command}\0"
    while line = s.gets
      if block_given?
        yield line
      else
        r << line
      end
    end
    s.close
    r == "" ? nil : r
  end

  alias :execute :execute!

end
