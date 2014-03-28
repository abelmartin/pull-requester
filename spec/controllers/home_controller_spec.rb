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
      it 'renders #index' do
        get :index
        response.status.should == 200
        controller.should render_template :index
      end
    end

    context "when user signed in" do
      let(:user){ FactoryGirl.create :user }
      before do
        sign_in(:user, user)
        session[:gh_token] = 'abcd'
      end

      it 'renders #index' do
        get :index
        response.status.should == 200
        controller.should render_template :index
      end

      it 'creates a Github client' do
        Github.should_receive(:new).with(oauth_token: 'abcd', auto_pagination: true)

        get :index
      end

      it 'assigns @repositories' do
        get :index
        expect(assigns :repositories).to eq(Repository.where(user_id: user.id))
      end

      it 'makes a GH client call for each @repository' do
        Github::Client.any_instance.should_receive(:pull_requests).exactly(3).times
        FactoryGirl.create_list :repository, 3, user:user

        get :index
      end

      it 'makes an 2 GH client calls for each @repository if verbose' do
        Github::Client.any_instance.should_receive(:pull_requests).exactly(4).times
        FactoryGirl.create_list :repository, 2, user:user

        get :index
      end

      context "when calling GH" do
        before do
          FactoryGirl.create :repository, user: user
          Github::Client.any_instance.stub_chain(:pull_requests, :all).and_return([{some_obj: 1}])
          Github::Client.any_instance.stub_chain(:issues, :assignees, :all).and_return(
            [{login: 'user1', avatar_url: 'avatar.png'}]
          )
        end

        it 'assigns any found open PRs to Repository#open_reqs' do
          get :index
          assigns(:repositories).first.open_reqs.should == [{some_obj: 1}]
        end

        it 'assigns any found assignees to Repository#assignees with first item empty' do
          get :index
          assigns(:repositories).first.assignees.should == [
            {login: '', avatar_url: ''},
            {login: 'user1', avatar_url: 'avatar.png'}
          ]
        end
      end
    end
  end
end