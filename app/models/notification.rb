class Notification < ApplicationRecord
  include Graphqlable

  SETTING = Settings.model.notification

  belongs_to :user
  belongs_to :actor, class_name: 'User', foreign_key: 'actor_id', optional: true
  belongs_to :resource, polymorphic: true

  enum action: SETTING.actions, _prefix: true
  enum kind: SETTING.kinds, _prefix: true
  enum status: SETTING.statuses, _prefix: true

  serialize :data

  validates :action, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end
