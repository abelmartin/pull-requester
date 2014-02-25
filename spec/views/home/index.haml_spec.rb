require "spec_helper"

describe "home/index.haml" do
  context "when user signed in" do

    context "when no repos are watched" do
      it "renders message to watch repos"
      it "does not render repos partial"
    end

    context "when atleast 1 repos is watched" do
      it "renders repos partial when any are watched"
      it "renders QuickAssign js for yield on bottom" do
        pending
        # once we get the devise helpers in play, we can address this.
        render
        view.content_for(:javascript_bottom).should =~ /QuickAssigner.*\.start\(\)/
      end
    end
  end

  context "when user is not signed in" do
    it "displays default message to sign in"
  end
end