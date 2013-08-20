require 'spec_helper'

describe User do
  describe 'attributes' do
    it {should respond_to :email}
    it {should respond_to :password}
    it {should respond_to :password_confirmation}
    it {should have_many :watches}
  end
end
