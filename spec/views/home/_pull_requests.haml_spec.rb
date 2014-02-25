require 'spec_helper'

describe 'home/_pull_requests' do
  let(:repo_objects) do
    [
      {
        head: {ref: FactoryGirl.generate( :branch_name )},
        html_url: Faker::Internet.http_url,
        title: 'repository1',
        owner: {login: Faker::Name.name.camelize},
        number: FactoryGirl.generate( :number ),
        user: {
          login: Faker::Internet.user_name,
          avatar_url: "#{Faker::Internet.http_url}/foo.png"
        }
      }
    ]
  end

  let(:assinees) do
    assignees_array = []
    3.times do |assignee|
      assignees_array << { login: Faker::Internet.user_name, avatar_url: Faker::Internet.http_url }
    end
  end

  let!(:repository){FactoryGirl.create :repository, open_reqs: repo_objects}

  it "calls markdown to render the PR body" do
    view.should_receive(:render_markdown).and_call_original
    render_pr_template
  end

  it "renders badge_image in expected area" do
    render_pr_template
    rendered.should have_css 'td.status_badge .badge_image'
  end

  it "renders pull request title" do
    # pending
    test_repo_number = repo_objects[0][:number]
    test_repo_title = repo_objects[0][:title]
    expected_string = "##{test_repo_number}: #{test_repo_title}"

    render_pr_template
    rendered.should have_selector('td.pull_info h4.repo_title', text: expected_string)
  end

  it "renders pull request owner and avatar" do
    render_pr_template
    pr_owner = repo_objects[0][:user]

    rendered.should have_css(
      "td.avatar a.creator_link img.avatar[src='#{pr_owner[:avatar_url]}']"
    )

    rendered.should have_selector(
      "td.avatar a.creator_link .pr_creator", text: pr_owner[:login]
    )
  end

  context "pull request assignee" do
    it "renders pull request assignee and avatar when present" do
      repo_objects[0][:assignee] = {login: Faker::Internet.user_name, avatar_url: "#{Faker::Internet.http_url}/bar.png"}

      render_pr_template
      rendered.should have_css(
        "td.avatar a.creator_link img.avatar[src='#{repo_objects[0][:assignee][:avatar_url]}']"
      )

      rendered.should have_selector(
        "td.avatar a.creator_link .pr_assignee", text: repo_objects[0][:assignee][:login]
      )
    end

    it "renders default 'unassigned' user & empty when absent" do
      repo_objects[0][:assignee] = {login: 'Unassigned', avatar_url: ''}

      render_pr_template
      rendered.should have_css(
        "td.avatar a.creator_link img.avatar[src='#{repo_objects[0][:assignee][:avatar_url]}']"
      )

      rendered.should have_selector(
        "td.avatar a.creator_link .pr_assignee", text: repo_objects[0][:assignee][:login]
      )
    end
  end

  private

  def render_pr_template
    render partial: 'pull_requests', locals: {repository: repository}
  end
end
