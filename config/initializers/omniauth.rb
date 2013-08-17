github_credentials = YAML.load_file("#{Rails.root}/config/github_credentials.yml")

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :github, github_credentials['client_id'], github_credentials['client_secret'], scope: 'user,repo'
end

#OmniAuth.config.logger = Rails.logger
