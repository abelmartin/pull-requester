class HomeController < ApplicationController
  def ping
    head :ok
  end

  def index
    if current_user
      gh = Github.new(oauth_token: session[:gh_token], auto_pagination: true)
      @repositories = current_user.repositories
      @repositories.each do |repo|
        begin
          repo.open_reqs = gh.pull_requests.all(repo.owner, repo.name)
          binding.pry
          # if current_user.verbose
          #   repo.open_reqs.each do |prs|
          #     detailed_pr = gh.pull_requests.find(repo.owner, repo.name, prs.number)
          #   end
          # end
          repo.assignees = [{login: '', avatar_url: ''}] # initialize
          gh.issues.assignees.all(repo.owner, repo.name).each do |assignee|
            repo.assignees.push( { login: assignee[:login], avatar_url: assignee[:avatar_url] } )
          end
        rescue Exception => e
          #Something went crazy when we tried to make this call.
          #Consider real messages in the future for 401 vs 404 vs 500,etc.
          repo.open_reqs = nil
        end
      end
    end
  end
end
