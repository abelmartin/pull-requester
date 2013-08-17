class HomeController < ApplicationController
  def index
    if current_user
      gh = Github.new(oauth_token: session[:gh_token])
      @watches = current_user.watches
      @watches.each do |watch|
        watch.open_reqs = gh.pull_requests.all(watch.repo_owner, watch.repo_name)
      end
    end
  end
end
