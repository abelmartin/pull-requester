require "spec_helper"

describe RepositoriesController do
  let(:user){ FactoryGirl.create :user }

  describe '#index' do
    it 'redirects if user not signed in' do
      get :index

      response.should redirect_to(new_user_session_path)
    end
  end

  describe '#create' do
    it 'redirects if user not signed in' do
      post :create

      response.should redirect_to(new_user_session_path)
    end
  end

  describe '#assign_user' do
    it 'redirects if user not signed in' do
      put :assign_user, {id: 5}

      response.should redirect_to(new_user_session_path)
    end
  end

  describe '#destroy' do
    let!(:repos){ FactoryGirl.create_list :repository, 2, user: user }

    it 'destroys a repository from the PRer db if the user is authenticated' do
      sign_in(:user, user)

      expect{ delete :destroy, id: repos.first.id }.to change{Repository.count}.from(2).to(1)
    end

    it 'redirects if user not signed in' do
      delete :destroy, id: repos.first.id

      response.should redirect_to(new_user_session_path)
    end

    it 'doesn\'t destroy the repo if the user doesn\'t own it' do
      sign_in(:user, FactoryGirl.create(:user))

      expect{ delete :destroy, id: repos.first.id }.not_to change{Repository.count}
    end
  end
end