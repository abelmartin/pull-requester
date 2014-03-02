require 'spec_helper'

describe HomeController do
  describe "#ping" do
    it 'should render head: :ok' do
      get :ping
      response.status.should == 200
      response.body.should be_blank
    end
  end

  describe "#index" do
    context "when user NOT signed in" do
      it 'should work :p'
    end

    context "when user signed in" do
      let(:user){ FactoryGirl.create :user }
      before do
        sign_in(:user, user)
        session[:gh_token] = 'abcd'
      end

      it 'creates a Github client' do
        Github.should_receive(:new).with(oauth_token: 'abcd', auto_pagination: true)

        get :index
      end

      it 'assigns @repositories'
      it 'makes a GH client call for each @repository'
      it 'assigns any found open PRs to Repository#open_reqs'
    end
  end
end