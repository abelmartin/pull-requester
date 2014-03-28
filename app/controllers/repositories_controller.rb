class RepositoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_repositories

  def index
    gh = Github.new(oauth_token: session[:gh_token], auto_pagination: true)

    if params[:org] || params[:user]
      get_repos_by_owner(gh)
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
      format.html
      format.json { render json: @grepositories }
    end
  end

  def create
    @repository = @repositories.build(acceptable_repository_params)

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
    @repositories.where(gh_id: params[:id]).try(:destroy_all)

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private

  def set_repositories
    @repositories = current_user.repositories
  end

  def get_repos_by_owner(gh)
    @gh_repos = []
    api_params = {}

    org = params[:org]
    user = params[:user]

    api_params[:org] = org if org
    api_params[:user] = user if user && org.nil?

    @owner = org || user

    @gh_repos = gh.repos.all(api_params)

    currently_watched = @repositories.to_a

    @gh_repos.each do |repo|
      repo[:watched] = currently_watched.one?{ |cw| cw.gh_id == repo[:id] }
    end

    @gh_repos = @gh_repos.sort_by{|repo| repo[:name].upcase}
  end

  def acceptable_repository_params
    params.require(:repository).permit(:user_id, :name, :owner, :gh_id)
  end
end
