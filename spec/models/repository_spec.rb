require 'spec_helper'

describe Repository do
  describe 'attributes' do
    it {should respond_to :gh_id}
    it {should respond_to :name}
    it {should respond_to :owner}
    it {should respond_to :open_reqs}
    it {should respond_to :assignees}
    it {should belong_to  :user}
    it {should belong_to  :build_service}
  end
end
