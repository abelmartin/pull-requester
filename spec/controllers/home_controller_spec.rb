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

      it 'assigns any found open PRs to Repository#open_reqs' do
        pending
        # prs_double = double
        # prs_double.stub(all: [{some_obj: 1}])
        prs_double = double(all: [{some_obj: 1}])
        Github::Client.any_instance.stub(pull_requests: prs_double)
        FactoryGirl.create_list :repository, 3, user:user

        get :index
        assigns(:repositories).first.open_reqs.should == [{some_obj: 1}, {some_obj: 1}, {some_obj: 1}]
        # expect(assigns(:repositories)).to eq([{some_obj: 1}, {some_obj: 1}, {some_obj: 1}])
      end
    end
  end
end