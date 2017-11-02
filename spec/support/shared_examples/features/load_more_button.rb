require 'rails_helper'

RSpec.shared_examples 'load more button' do |css_selector, init_item_count, min_item_count|
  include WaitSteps

  it 'load more when click load more' do
    expect { find_all(css_selector).count == init_item_count }.to become_true
    click_on 'More'
    wait_animation
    expect { find_all(css_selector).count >= min_item_count }.to become_true
  end
end
