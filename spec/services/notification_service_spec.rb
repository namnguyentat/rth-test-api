require 'rails_helper'

RSpec.describe NotificationService do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:comment) { create(:comment, user: user) }
  let!(:notification) do
    create(
      :notification,
      user: user,
      action: Notification.actions[:upvote_comment],
      actor: other_user,
      resource: comment
    )
  end

  it 'runs successfully' do
    result = NotificationService.new(notification).call
    expect(result).to be_truthy
  end
end
