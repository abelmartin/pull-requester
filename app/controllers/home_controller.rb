class HomeController < ApplicationController
  def ping
    head :ok
  end

  def index
    if current_user
      gh = Github.new(oauth_token: session[:gh_token])
      @watches = current_user.watches
      @watches.each do |watch|
        begin
          watch.open_reqs = gh.pull_requests.all(watch.repo_owner, watch.repo_name)
          # binding.pry
          # gh.pull_requests.find(watch.repo_owner, watch.repo_name, 1288).body
        rescue
          #Something went crazy when we tried to make this call.
          #Consider real messages in the future for 401 vs 404 vs 500,etc.
          watch.open_reqs = nil
        end
      end

    end
  end
end
