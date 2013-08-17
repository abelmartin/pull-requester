if File.exists?("#{Rails.root}/config/github_credentials.yml")
  github_credentials = YAML.load_file("#{Rails.root}/config/github_credentials.yml")
else
  github_credentials = {
    'client_id' => ENV['GH_CLIENT_ID'],
    'client_secret' => ENV['GH_CLIENT_SECRET']
  }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :github, github_credentials['client_id'], github_credentials['client_secret'], scope: 'user,repo'
end

#OmniAuth.config.logger = Rails.logger
