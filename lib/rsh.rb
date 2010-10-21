class Rsh
  attr_reader   :executable
  attr_accessor :command

  def initialize(command="")
    begin
      open("| which rsh") do |io|
        @executable = io.gets.chomp
      end

      @command = command

    rescue => detail
      raise "FATAL: Could not find rsh executable!"
    end
  end

  def execute
    true
  end

end
