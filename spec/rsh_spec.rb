require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "rsh" do
    it "Finds rsh executable" do
      rsh = Rsh.new
      rsh.executable.should_not == ""
    end
end
