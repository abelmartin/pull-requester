class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_by_omni_uid(auth_hash[:uid])

    if @user
      store_gh_token
      sign_in_and_redirect @user, :event => :authentication
    else
      @user = User.new.tap do |u|
        u.omni_uid = auth_hash[:uid]
        u.omni_provider = 'Github'
        u.name = auth_hash[:info][:name]
        u.email = "#{auth_hash[:info][:nickname]}@users.noreply.github.com"
        u.avatar_url = auth_hash[:info][:image]
        u.github_url = auth_hash[:info][:urls][:GitHub]
        u.github_login = auth_hash[:extra][:raw_info][:login]
      end

      new_password = SecureRandom.uuid
      @user.password = new_password
      @user.password_confirmation = new_password
      @user.save

      store_gh_token
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth'].with_indifferent_access
  end

  def store_gh_token
    session[:gh_token] = auth_hash[:credentials][:token]
  end
end
