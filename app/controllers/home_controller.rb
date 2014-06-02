class HomeController < ApplicationController
  def ping
    head :ok
  end

  def index
    if current_user
      gh = GithubClientWrapper.get_client(session[:gh_token], request.subdomain)
      @repositories = current_user.repositories
      @repositories.each do |repo|
        begin
          repo.open_reqs = gh.pull_requests.all(repo.owner, repo.name)
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
    else
      if ['', 'www', 'local'].include?(request.subdomain)
        @oauth_gh_context = :github
      else
        @oauth_gh_context = request.subdomain.to_sym
      end
    end
  end
end
