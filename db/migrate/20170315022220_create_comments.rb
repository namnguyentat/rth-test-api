class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :commentable, polymorphic: true
      t.references :user, foreign_key: true

      t.text :content, null: false

      t.integer :upvote_count, null: false, default: 0
      t.integer :reply_count, null: false, default: 0
      t.integer :report_count, null: false, default: 0

      t.timestamps
    end
  end
end
