class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    gh = Github.new(oauth_token: session[:gh_token])
    org = user = nil
    @projects = current_user.projects

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

      #let's add the project_id if it matches one we're watching
      @gh_repos.each do |repo|
        repo[:project_id] = @projects.find_by_gh_id(repo[:id]).try(:id)
      end

      @gh_repos.sort_by!{|repo| repo[:name].upcase}
    else
      @orgs = gh.orgs.all.to_a
      @orgs << {
        login: current_user.github_login,
        repos_url: current_user.github_url,
        avatar_url: current_user.avatar_url
      }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def create
    @project = current_user.projects.build(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Repository successfully added.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { redirect_to projects_url, notice: 'Failed to watch repositories.' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    current_user.projects.find(params[:id]).try(:destroy)

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
