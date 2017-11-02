class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :followable, polymorphic: true, counter_cache: :follower_count

  validates :user_id, :followable_id, :followable_type, presence: true
  validates :user_id, uniqueness: {scope: [:followable_id, :followable_type]}

  after_create :increase_following_count
  after_destroy :decrement_following_count

  scope :with_followable_type, ->(type) { where(followable_type: type) }

  private

  def increase_following_count
    User.increment_counter("following_#{followable_type.downcase}_count", user_id)
  end

  def decrement_following_count
    User.decrement_counter("following_#{followable_type.downcase}_count", user_id)
  end
end
