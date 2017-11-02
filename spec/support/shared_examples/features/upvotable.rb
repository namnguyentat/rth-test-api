require 'rails_helper'

RSpec.shared_examples 'upvotable' do |klass|
  include WaitSteps

  let(:factory_name) { klass.name.downcase.to_sym }
  let(:route_prefix) { "/#{klass.name.downcase.pluralize}" }
  let!(:object) { create factory_name }
  let!(:user) { create :user, onboarding: 'completed' }

  before(:each) do
    login_as_user(user)
    visit "#{route_prefix}/#{graphql_id(object)}"
    click_button(title: 'Upvote')
  end

  it 'upvoted successfully' do
    expect(page).to have_content('1')
    expect { object.upvoters.include?(user) }.to become_true
  end
end
