#= Pure ruby RSH client implementation
#
# This implementation's idea is taken from Perl implementation, Net::Rsh
# by Oleg Prokopyev, <riiki@gu.net>
module RshPR
  require 'socket'
  # force pure ruby rsh client
  attr_accessor :ruby_impl
  # Local user name, used in pure ruby implementation.
  attr_accessor :luser

  # Specific constructor: additional parmeter key added:
  # * :ruby_impl -- turns on pure ruby implementation of RSH protocol client.
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

    begin
      if @ruby_impl
        @executable = :ruby_impl
      else
        open("| which rsh") do |io|
          @executable = io.gets.chomp
        end
      end
    rescue => detail
      @executable = :ruby_impl
    end
  end

  def execute!(command=nil)
    @command = command if command
    @result = ""
    if @executable == :ruby_impl
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
end