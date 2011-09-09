require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rsh do

  def init_them
    @rsh  = Rsh.new
    @rshc = `which rsh`.chomp
  end

  #
  # Basic fields interface checklist
  #
  context "has the following fields interface" do
    before :each do init_them end

    shared_examples "existing reader" do |sym|
      it "should exist" do
        @rsh.should respond_to sym
      end
      it "should get the value" do
        @rsh.send(sym).should_not be_nil
      end
    end

    shared_examples "accessor" do |sym|
      it_behaves_like "existing reader", sym
      it "should set the value" do
        v = 123
        @rsh.send((((sym.to_s) + '=').to_sym), v).should == v
      end
    end
    shared_examples "reader" do |sym|
      it_behaves_like "existing reader", sym
      it "should NOT set the value" do
        v = 123
        expect {@rsh.send((((sym.to_s) + '=').to_sym), v)}.to raise_error
      end
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
        it_behaves_like "accessor", sym
      end
    end

    [
      :executable,
      :result
    ].each do |sym|
      describe sym do
        it_behaves_like "reader", sym
      end
    end

  end

  #
  # Constructor tests
  #
  context "has the following construction variants" do
    it "creates the instance with default values" do
      Rshc
      rsh = Rsh.new
      rsh.host.should    ==    "localhost"
      rsh.command.should ==    ""
      rsh.ruser.should   ==    "nobody"
      rsh.luser.should   match /(#{ENV['USER']})|(nobody)/
    end
    it "creates the instance with given values" do
      args = {
        :host      => "foo.bar.com",
        :command   => "echo bar",
        :ruser     => "r00dt",
        :luser     => "h4X0r",
        :to        => 3,
        :nullr     => true,
        :ruby_impl => true
      }

      rsh = Rsh.new args

      args.each do |k,v|
        rsh.send(k).should == v
      end
    end
  end

  context "upon instance creation" do
    it "has empty result field" do
      Rsh.new.result.should be_empty
    end

    it "sets the rsh implementation to system if rsh command is found in the system" do
      Rshc.stub(:find).and_return("/usr/bin/rsh")
      Rsh.new.ruby_impl.should be_false
    end

    it "sets the rsh implementation to pure ruby otherwise" do
      Rshc.stub(:find).and_return("")
      Rsh.new.ruby_impl.should be_true
    end
  end

  context "when rsh(1) isn't present in the system" do
    it "forces ruby implementation despite the :ruby_impl flag" do
      Rshc.stub(:find).and_return("")
      rsh = Rsh.new :ruby_impl => false
      rsh.executable.should be_empty
      rsh.ruby_impl.should  be_true
      rshc = "/usr/bin/rsh"
      Rshc.stub(:find).and_return(rshc)
      rsh = Rsh.new :ruby_impl => false
      rsh.executable.should == rshc
      rsh.ruby_impl.should  be_false
    end
  end

  #
  # Specific behavior tests
  #
  context "has the following specific behavior" do
    before :each do init_them end

    describe "#executable" do
      it "shows the system rsh program path" do
        @rsh.executable.should == @rshc
        ["", "/usr/bin/rsh"].each do |x|
          Rshc.stub(:find).and_return(x)
          Rsh.new.executable.should == x
        end
      end
    end

    describe "#ruby_impl" do
      it "shows whether the active rsh implementation is pure ruby"
      #Rshc.stub(:find).and_return("/usr/bin/rsh")
      #Rsh.new(:ruby_impl => true).ruby_impl.should  be_true
      #Rsh.new(:ruby_impl => false).ruby_impl.should be_false
    end
    describe "#ruby_impl=" do
      it "sets the current rsh implementation flag"
      context "when rsh executable isn't present in the system" do
        it "fails to unset ruby implementation"
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

