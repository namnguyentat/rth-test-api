class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.string :name
      t.text :about
      t.string :company
      t.string :job
      t.text :avatar
      t.string :email
      t.integer :onboarding, null: false

      t.string :facebook_id, index: true
      t.string :google_id, index: true
      t.string :facebook_oauth_access_token
      t.text :facebook_friends

      t.integer :follower_count, null: false, default: 0
      t.integer :following_user_count, null: false, default: 0
      t.integer :bookmark_post_count, null: false, default: 0
      t.integer :unseen_notification_count, null: false, default: 0
      t.integer :post_count, null: false, default: 0, index: true
      t.integer :comment_count, null: false, default: 0, index: true
      t.integer :reply_count, null: false, default: 0, index: true
      t.integer :like_count, default: 0

      t.integer :notification_mode, null: false, default: 0

      t.timestamps
    end
  end
end
