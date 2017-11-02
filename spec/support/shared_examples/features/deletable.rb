require 'rails_helper'

RSpec.shared_examples 'deletable' do |klass|
  include WaitSteps

  let(:factory_name) { klass.name.downcase.to_sym }
  let(:route_prefix) { "/#{klass.name.downcase.pluralize}" }
  let!(:user) { create :user, onboarding: 'completed' }
  let!(:object) { create factory_name, user: user }

  before(:each) do
    login_as_user(user)
    visit "#{route_prefix}/#{graphql_id(object)}"
    find(".#{klass.name.downcase}-extra-actions-t").click
    click_button 'Delete'
    wait_animation
    click_button 'Yes'
  end

  it 'deleted successfully' do
    expect { !object.class.exists?(id: object.id) }.to become_true
  end
end
