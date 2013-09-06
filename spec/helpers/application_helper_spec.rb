require 'spec_helper'

describe ApplicationHelper do
  describe "#circle_ci_badge" do
    it "creates a url in the right format" do
      badge_url = helper.circle_ci_badge('owner', 'my_repo', 'my_branch')
      badge_url.should =~ /src.*https.*circleci\.com\/gh\/owner\/my_repo\/tree\/my_branch\.png.*/
    end

    it "HTML encodes owner & repo names in the url" do
      badge_url = helper.circle_ci_badge('owner/slash', 'my_repo/slash', 'my_branch/slash')
      badge_url =~ /src.*https.*owner\%2fslash/
      badge_url =~ /src.*https.*my_repo\%2fslash/
      badge_url =~ /src.*https.*my_branch\%2fslash/
    end

    it "has 'onerror' attribute" do
      badge_url = helper.circle_ci_badge('owner', 'my_repo', 'my_branch')
      badge_url.should have_selector('[onerror]')
    end
  end
end
