class Upvote < ApplicationRecord
  belongs_to :user
  belongs_to :upvotable, polymorphic: true, counter_cache: :upvote_count

  validates :user_id, :upvotable_id, :upvotable_type, presence: true
  validates :user_id, uniqueness: {scope: [:upvotable_id, :upvotable_type]}
end
