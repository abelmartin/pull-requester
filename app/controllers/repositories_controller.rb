class RepositoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_repositories

  def index
    gh = Github.new(oauth_token: session[:gh_token])
    org = user = nil

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

      #let's add the local_gh_id if it matches one we're watching
      @gh_repos.each do |repo|
        repo[:local_gh_id] = @repositories.find_by_gh_id(repo[:id]).try(:id)
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
      format.json { render json: @repositories }
    end
  end

  def create
    @repository = @repositories.build(params[:repository])

    respond_to do |format|
      if @repository.save
        format.html { redirect_to repositories_url, notice: 'Repo successfully added.' }
        format.json { render json: @repository, status: :created, location: @repository }
      else
        format.html { redirect_to repositories_url, notice: 'Failed to watch repo.' }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def assign_user
    begin
      repository = @repositories.find_by_id params[:id]
      gh = Github.new(oauth_token: session[:gh_token], auto_pagination: true)

      gh.issues.edit(
        repository.owner,
        repository.name,
        params[:pull_number],
        assignee: params[:assignee_login]
      )

      render json: {success: true}
    rescue Exception => e
      render json: {success: false, errors: e}, status: 500
    end
  end

  def destroy
    @repositories.find_by_id(params[:id]).try(:destroy)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_repositories
    @repositories = current_user.repositories
  end
end
