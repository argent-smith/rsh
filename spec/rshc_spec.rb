require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rshc do
  describe "find" do
    it "returns the system's rsh path" do
      Rshc.find.should == `which rsh`.chomp
    end
  end
end

