require "spec_helper"

describe RepositoriesController do
  let(:user){ FactoryGirl.create :user }

  describe '#index' do
    it 'redirects if user not signed in' do
      get :index

      response.should redirect_to(new_user_session_path)
    end

    context 'when user is signed in' do
      before do
        sign_in(:user, user)
        session[:gh_token] = 'ab12cd34'
      end

      it 'gets all orgs the user can see' do
        Github::Client.
          should_receive(:new).
          and_return( double({orgs: double({all: []}) }) )

        get :index
      end

      context 'when scoping params are passed' do
        before do
          Github::Client.any_instance.stub_chain(:repos, :all).and_return([])
        end

        it 'assigns org param as owner' do
          get :index, org: 'FooBar'
          assigns(:owner).should == 'FooBar'
        end

        it 'assigns user param as owner' do
          get :index, user: 'BarBaz'
          assigns(:owner).should == 'BarBaz'
        end

        it 'assigns org param as owner if user && org are passed' do
          get :index, org: 'FooBar', user: 'BarBaz'
          assigns(:owner).should == 'FooBar'
        end

        it 'gets the current user\'s repo' do
          pending
        end
      end
    end
  end

  describe '#create' do
    it 'redirects if user not signed in' do
      post :create

      response.should redirect_to(new_user_session_path)
    end

    context "when user is signed in" do
      let(:repo_params) do
        attrs = FactoryGirl.attributes_for :repository, user: user
        attrs.delete :assignees
        attrs.delete :open_reqs

        attrs
      end

      before { sign_in(:user, user) }

      it 'creates a repo to watch in the db when valid info passed with HTML response' do
        post :create, {repository: repo_params}

        response.should redirect_to(repositories_url)
        flash[:notice].should == 'Repo successfully added.'
        Repository.where(
          name: repo_params[:name], owner: repo_params[:owner]
        ).count.should == 1
      end

      it 'creates a repo to watch in the db when valid info passed with JSON response' do
        post :create, {repository: repo_params, format: 'json'}

        last_repo = Repository.last
        JSON.parse(response.body)['id'].should == last_repo.id
        JSON.parse(response.body)['name'].should == last_repo.name
        JSON.parse(response.body)['owner'].should == last_repo.owner
        JSON.parse(response.body)['user_id'].should == user.id
      end

      it 'returns an error if invalid data present with HTML response' do
        repo_params.delete :owner
        post :create, {repository: repo_params}

        response.should redirect_to(repositories_url)
        flash[:notice].should == 'Failed to watch repo.'
      end

      it 'returns an error if invalid data present with JSON response' do
        repo_params.delete :owner
        post :create, {repository: repo_params, format: 'json'}

        response.status.should == 422
        response.body.should == {"owner" => ["can't be blank"]}.to_json
      end
    end
  end

  describe '#assign_user' do
    it 'redirects if user not signed in' do
      put :assign_user, {id: 0}

      response.should redirect_to(new_user_session_path)
    end

    context 'when user signed in' do
      before do
        sign_in(:user, user)
        session[:gh_token] = 'abcd'
        Github::Client.should_receive(:new).with(oauth_token: 'abcd', auto_pagination: true).and_call_original
      end

      it 'creates a gh client' do
        put :assign_user, {id: 0}
        response.status.should == 500 #This should explode
      end

      it 'gh client calls #edit with necessary params' do
        repo = FactoryGirl.create :repository, user: user

        Github::Client.any_instance.stub_chain(:issues, :edit).and_return({success: true})
        put :assign_user, {id: repo.id}

        response.body.should == {success: true}.to_json
      end
    end
  end

  describe '#destroy' do
    let!(:repos){ FactoryGirl.create_list :repository, 2, user: user }

    it 'destroys a repository from the PRer db if the user is authenticated' do
      sign_in(:user, user)

      expect{ delete :destroy, id: repos.first.gh_id }.to change{Repository.count}.from(2).to(1)
    end

    it 'redirects if user not signed in' do
      delete :destroy, id: repos.first.gh_id

      response.should redirect_to(new_user_session_path)
    end

    it 'doesn\'t destroy the repo if the user doesn\'t own it' do
      sign_in(:user, FactoryGirl.create(:user))

      expect{ delete :destroy, id: repos.first.gh_id }.not_to change{Repository.count}
    end
  end
end