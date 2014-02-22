FactoryGirl.define do
  sequence(:gh_id) {|n| n + 1000 }
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

  factory :repository do
    user
    name { Bazaar.heroku }
    owner { Faker::Name.name.camelize }
    gh_id { generate :gh_id }
    assignees {[]}
    open_reqs {[]}
  end
end
