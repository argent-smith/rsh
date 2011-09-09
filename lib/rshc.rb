# Finds and stores system rsh command data
class Rshc

  # Called without arguments. Finds and stores rsh(1) command data
  def initialize
    @path = Rshc.find
  end

  # Returns rsh(1) path
  attr_reader :path

  class << self
    # calls `which rsh` and returns the result (either rsh(1) path or "").
    # Defined as a class method in order to be mocked easily in BDD.
    def find
      begin
        `which rsh`.chomp
      rescue
        ""
      end
    end
  end
end
