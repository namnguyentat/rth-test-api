require 'rails_helper'

RSpec.shared_examples 'bookmarkable' do |klass|
  include WaitSteps

  let(:factory_name) { klass.name.downcase.to_sym }
  let(:route_prefix) { "/#{klass.name.downcase.pluralize}" }
  let!(:object) { create factory_name }
  let!(:user) { create :user, onboarding: 'completed' }

  before(:each) do
    login_as_user(user)
    visit "#{route_prefix}/#{graphql_id(object)}"
    find(".#{klass.name.downcase}-extra-actions-t").click
    click_button 'Bookmark'
  end

  it 'bookmarked successfully' do
    expect(page).to have_content('Bookmarked')
    expect { object.bookmarkers.include?(user) }.to become_true
  end
end
