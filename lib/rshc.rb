# Finds and stores system rsh command data
class Rshc

  # Called without arguments. Finds and stores rsh(1) command data
  def initialize
    begin
      @path = `which rsh`.chomp
    rescue
      @path = ""
    end
  end

  # Returns rsh(1) path
  attr_reader :path
end
