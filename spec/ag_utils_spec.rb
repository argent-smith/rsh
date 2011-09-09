require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AgUtils do
  describe AgUtils::Rbx, "the rbx detection tool" do
    describe "#found?" do
      it "returns true when this ruby is rbx" do
        begin
          if RUBY_ENGINE == "rbx"
            rc = AgUtils::Rbx.found?.should be_true
          else
            AgUtils::Rbx.found?.should be_false
          end
        rescue NameError
            AgUtils::Rbx.found?.should be_false
        end
      end
    end
  end
end

