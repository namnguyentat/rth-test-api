require 'rails_helper'

RSpec.shared_examples 'commentable' do |klass|
  include WaitSteps

  let(:factory_name) { klass.name.downcase.to_sym }
  let!(:object) { create factory_name }
  let(:route_prefix) { "/#{klass.name.downcase.pluralize}" }
  let!(:user) { create :user, onboarding: 'completed' }
  let(:content) { "comment content - #{Time.now}" }

  before(:each) do
    login_as_user(user)
    visit "#{route_prefix}/#{graphql_id(object)}"
    find('textarea', id: 'content').send_keys content
    click_button 'Submit'
  end

  it 'comment is saved to the db' do
    expect(page).to have_content(content)
    expect { object.comments.exists?(content: content) }.to become_true
  end
end
