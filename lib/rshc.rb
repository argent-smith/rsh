# :nodoc:
class Rshc
  attr_reader :path
  def initialize
    begin
      @path = `which rsh`.chomp
    rescue
      @path = ""
    end
  end
end
