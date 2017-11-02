require 'rails_helper'

RSpec.shared_examples 'paginatable by scrolling' do |css_selector, min_item_count|
  include WaitSteps

  it 'load more when scroll to bottom' do
    wait_animation
    page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
    wait_animation
    expect { find_all(css_selector).count >= min_item_count }.to become_true
  end
end
