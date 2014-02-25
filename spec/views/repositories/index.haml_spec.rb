require "spec_helper"

describe "repositories/index" do
  it "renders javascript in yield" do
    render
    view.content_for(:javascript_bottom).should =~ /new ToggleRepositoryWatch\(.*\)/
  end
end