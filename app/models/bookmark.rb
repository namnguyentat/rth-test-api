class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true, counter_cache: :bookmark_count

  validates :user_id, :bookmarkable_id, :bookmarkable_type, presence: true
  validates :user_id, uniqueness: {scope: [:bookmarkable_id, :bookmarkable_type]}

  after_create :increase_bookmark_count
  after_destroy :decrement_bookmark_count

  scope :post, -> { where(bookmarkable_type: 'Post') }

  private

  def increase_bookmark_count
    User.increment_counter("bookmark_#{bookmarkable_type.downcase}_count", user_id)
  end

  def decrement_bookmark_count
    User.decrement_counter("bookmark_#{bookmarkable_type.downcase}_count", user_id)
  end
end
