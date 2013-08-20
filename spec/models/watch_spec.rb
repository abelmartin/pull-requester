require 'spec_helper'

describe Watch do
  describe 'attributes' do
    it {should respond_to :repo_id}
    it {should respond_to :repo_name}
    it {should respond_to :repo_owner}
    it {should belong_to :user}
    it {should respond_to :open_reqs}
  end
end
