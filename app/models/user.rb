class User < ApplicationRecord
  include Graphqlable

  SETTING = Settings.model.user

  enum onboarding: SETTING.onboardings, _prefix: true
  enum notification_mode: SETTING.notification_modes, _prefix: true

  serialize :facebook_friends

  has_many :notifications, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :follows, as: :followable, dependent: :destroy
  has_many :followers, through: :follows, source: :user

  has_many :followings, class_name: 'Follow', dependent: :destroy, source: :user
  has_many :following_users, through: :followings, source: :followable, source_type: 'User'
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_posts, through: :bookmarks, source: :bookmarkable, source_type: 'Post'
end
