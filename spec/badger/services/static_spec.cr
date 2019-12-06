require "../../spec_helper"

describe "static badges" do
  it "should get label and value correctly" do
    with_json_badge "/static?label=hello&value=world" do
      badge.label.should eq "hello"
      badge.value.should eq "world"
    end
  end
end
