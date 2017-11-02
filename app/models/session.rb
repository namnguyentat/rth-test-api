class Session < ApplicationRecord
  include Graphqlable

  belongs_to :user

  validates :user_id, presence: true
  validates :access_token, presence: true

  def self.user_from_access_token(access_token)
    session = Session.find_by(access_token: access_token)
    (session && !session.expired?) ? session.user : nil
  end

  def expired?
    expires_at <= Time.now
  end
end
