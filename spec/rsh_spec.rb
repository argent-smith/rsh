require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rsh do

  context "has the basic interface" do
    shared_examples "accessor" do
      it "should get the value"
      it "should set the value"
    end
    shared_examples "reader" do
      it "should get the value"
      it "should NOT set the value"
    end

    [
      :ruby_impl,
      :host,
      :command,
      :ruser,
      :luser,
      :to,
      :nullr
    ].each do |sym|
      describe sym do
        it_behaves_like "accessor"
      end
    end

    [
      :executable,
      :result
    ].each do |sym|
      describe sym do
        it_behaves_like "reader"
      end
    end

  end

  context "has the following construction variants" do
    it "creates the instance with default values"
    it "creates the instance with given values"
  end

  context "upon instance creation" do
    it "sets the rsh implementation to system if rsh command is found in the system"
    it "sets the rsh implementation to native otherwise"
    it "has empty result field"
  end

  context "has the following specific behavior" do

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
      shared_examples "expected" do
        it "runs the command"
        it "retuns the result"
        it "stores the result in @result"
      end
      shared_examples "in either implementation" do
         context "in batch execution mode" do
           it_behaves_like "expected"
         end
         context "in block execution mode" do
           it_behaves_like "expected"
         end
      end
      context "with system implementation" do
        it_behaves_like "in either implementation"
      end
      context "with pure ruby implementation" do
        it_behaves_like "in either implementation"
      end
    end
  end
end

