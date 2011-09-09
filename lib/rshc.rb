# Finds system rsh(1) command data
module Rshc
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
