require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rshc do
  describe "#initialize" do
    it "should be called without arguments" do
      expect { Rshc.new true }.to raise_error 
    end
  end
  describe "#path" do
    it "returns the system's rsh path" do
      Rshc.new.path.should == `which rsh`.chomp
    end
  end
end

