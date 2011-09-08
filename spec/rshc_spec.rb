require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rshc do
  describe "#path" do
    it "returns the system's rsh path" do
      Rshc.new.path.should == `which rsh`.chomp
    end
  end
end

