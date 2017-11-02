class Post < ApplicationRecord
  include Graphqlable

  belongs_to :user, counter_cache: :post_count

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :notifications, as: :resource, dependent: :destroy

  has_many :upvotes, as: :upvotable, dependent: :destroy
  has_many :upvoters, through: :upvotes, source: :user

  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :bookmarkers, through: :bookmarks, source: :user
end
