class Comment < ApplicationRecord
  include Graphqlable

  belongs_to :commentable, polymorphic: true, counter_cache: :comment_count
  belongs_to :user, counter_cache: :comment_count

  has_many :notifications, as: :resource, dependent: :destroy
  has_many :replies, dependent: :destroy

  has_many :upvotes, as: :upvotable, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user

  scope :with_commentable_type, ->(type) { where(commentable_type: type) }
end
