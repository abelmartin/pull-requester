if File.exists?("#{Rails.root}/config/github_oauth_credentials.yml")
  github_credentials = YAML.load_file("#{Rails.root}/config/github_oauth_credentials.yml")
else
  github_credentials = {
    'client_id' => ENV['GH_CLIENT_ID'],
    'client_secret' => ENV['GH_CLIENT_SECRET'],
  }

  if ENV['GH_CLIENT_OPTIONS']
    github_credentials['client_options'] = JSON.parse( ENV['GH_CLIENT_OPTIONS'] )
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  gh_options = {scope: 'user,repo'}

  if github_credentials['client_options']
    gh_options.merge!(
      { client_options: github_credentials['client_options'] }
    )
  end

  provider :github,
    github_credentials['client_id'],
    github_credentials['client_secret'],
    gh_options.with_indifferent_access
end

#OmniAuth.config.logger = Rails.logger
