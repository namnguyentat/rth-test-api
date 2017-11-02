require 'rails_helper'

RSpec.shared_examples 'undownvotable' do |klass|
  include WaitSteps

  let(:factory_name) { klass.name.downcase.to_sym }
  let(:route_prefix) { "/#{klass.name.downcase.pluralize}" }
  let!(:object) { create factory_name }
  let!(:user) { create :user, onboarding: 'completed' }

  before(:each) do
    login_as_user(user)
    object.downvoters << user
    visit "#{route_prefix}/#{graphql_id(object)}"
    click_button(title: 'Downvote')
  end

  it 'undownvoted successfully' do
    expect { !object.downvoters.include?(user) }.to become_true
  end
end
