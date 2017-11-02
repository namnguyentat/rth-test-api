class Reply < ApplicationRecord
  include Graphqlable

  belongs_to :comment, counter_cache: :reply_count
  belongs_to :user, counter_cache: :reply_count

  has_many :notifications, as: :resource, dependent: :destroy

  has_many :upvotes, as: :upvotable, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user
end
