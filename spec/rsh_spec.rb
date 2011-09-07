require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rsh do

  it "creates the instance with default values"
  it "creates the instance with given values"

  context "when the instance is created" do
    it "sets the rsh implementation to system if rsh command is found in the system"
    it "sets the rsh implementation to native otherwise"
    it "has empty result field"
  end

  context "has the following generic behavior" do

    describe "#executable" do
      it "shows the system rsh program path"
    end

    describe "#ruby_impl" do
      it "shows the current rsh implementation"
      it "sets the current rsh implementation"

      context "when rsh executable isn't present in the system" do
        it "fails to set implementation to system"
      end
    end

    describe "#execute" do
      context "with system implementation" do
        context "in batch execution mode" do
          it "runs the command"
          it "shows the result with #result"
        end
        context "in block execution mode" do
          it "runs the command"
          it "shows the result with #result"
        end
      end
      context "with pure ruby implementation" do
        context "in batch execution mode" do
          it "runs the command"
          it "shows the result with #result"
        end
        context "in block execution mode" do
          it "runs the command"
          it "shows the result with #result"
        end
      end
    end
  end
end

