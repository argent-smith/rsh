#= Pure ruby RSH client implementation
#
# This implementation's idea is taken from Perl implementation, Net::Rsh
# by Oleg Prokopyev, <riiki@gu.net>
module RshPR
  require 'socket'
  class Rsh

    # Local user name, used in pure ruby implementation.
    attr_accessor :luser

    def initialize(args={})
      args = {
        :host    => "localhost",
        :command => "",
        :ruser   => "nobody",
        :luser   => ENV["USER"] || "nobody",
        :to      => 3,
        :nullr   => false
      }.merge!(args)
      begin
        open("| which rsh") do |io|
          @executable = io.gets.chomp
        end
      rescue => detail
        @executable = :self_impl
      end

      @host    = args[:host]
      @command = args[:command]
      @ruser   = args[:ruser]
      @to      = args[:to]
      @nullr   = args[:nullr]
      @result  = ""
    end
    
    def execute!(command=nil)
      @command = command if command
      @result = ""
      if @executable == :self_impl
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
end