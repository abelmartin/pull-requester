FactoryGirl.define do
  sequence(:repo_id) {|n| n + 1000 }
  sequence(:omni_uid) {|n| n + 500 }
  sequence(:email) { |n| "#{n}@example.com" }

  factory :user do
    email {generate :email}
    password "password"
    omni_uid {generate :omni_uid}
    omni_provider 'Github'
    name {Faker::Name.name}
    avatar_url {Faker::Internet.url}
    github_url {Faker::Internet.url}
    github_login {Faker::Internet.user_name}
  end

  factory :watch do
    user
    repo_name {Bazaar.heroku}
    repo_owner {Faker::Name.name.camelize}
    repo_id {generate :repo_id}
  end
end
