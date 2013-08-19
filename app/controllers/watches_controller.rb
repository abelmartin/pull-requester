class WatchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    gh = Github.new(oauth_token: session[:gh_token])
    org = user = nil
    @watches = current_user.watches

    if org = params[:org] || user = params[:user]
      @gh_repos = []

      api_params = { page: 0, per_page: 100 }

      api_params[:user] = user if user
      api_params[:org] = org if org

      @owner = org || user

      loop do
        api_params[:page] += 1
        paged_repos = gh.repos.all(api_params)
        break if paged_repos.empty?
        @gh_repos |= paged_repos.to_a
      end

      #let's add the watch_id if it matches one we're watching
      @gh_repos.each do |repo|
        repo[:watch_id] = @watches.find_by_repo_id(repo[:id]).try(:id)
      end

      @gh_repos.sort_by!{|repo| repo[:name].upcase}
    else
      @orgs = gh.orgs.all.to_a
      @orgs << {
        login: current_user.github_login,
        repos_url: current_user.github_url,
        avatar_url: current_user.avatar_url
      }
      @orgs.sort_by!{|org| org[:login].downcase}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @watches }
    end
  end

  def create
    @watch = current_user.watches.build(params[:watch])

    respond_to do |format|
      if @watch.save
        format.html { redirect_to watches_url, notice: 'Repo successfully added.' }
        format.json { render json: @watch, status: :created, location: @watch }
      else
        format.html { redirect_to watches_url, notice: 'Failed to watch repo.' }
        format.json { render json: @watch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user.watches.find_by_repo_id(params[:id]).try(:destroy)

    respond_to do |format|
      format.html { redirect_to watches_url }
      format.json { head :no_content }
    end
  end
end
