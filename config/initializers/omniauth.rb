if File.exists?("#{Rails.root}/config/github_credentials.yml")
  github_credentials = YAML.load_file("#{Rails.root}/config/github_credentials.yml")
else
  github_credentials = {
    'client_id' => ENV['GH_CLIENT_ID'],
    'client_secret' => ENV['GH_CLIENT_SECRET']
  }
end

gcw_config = GithubClientWrapper.configuration

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :github,
  #   github_credentials['client_id'],
  #   github_credentials['client_secret'],
  #   scope: 'user,repo'

  gcw_config[:providers].each do |gh_provider, gh_config_data|
    if gh_provider == 'github'
      provider :github,
        gh_config_data[:client_id],
        gh_config_data[:client_secret],
        scope: 'user,repo'
    else
      provider gh_provider.to_sym,
        gh_config_data[:client_id],
        gh_config_data[:client_secret],
        scope: 'user,repo',
        client_options: gh_config_data[:client_options]
    end
  end
end

#OmniAuth.config.logger = Rails.logger
