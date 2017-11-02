class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.text :title, limit: 1000
      t.text :image, limit: 1000
      t.text :content, limit: 16.megabytes -  1

      t.integer :bookmark_count, null: false, default: 0
      t.integer :comment_count, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :report_count, null: false, default: 0
      t.integer :view_count, null: false, default: 0

      t.timestamps
    end

    add_index :posts, :created_at
  end
end
