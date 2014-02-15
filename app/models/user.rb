class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:github]

  has_many :repositories

  attr_accessible :email, :password, :password_confirmation, :remember_me
end
