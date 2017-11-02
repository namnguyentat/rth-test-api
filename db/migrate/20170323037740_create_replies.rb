class CreateReplies < ActiveRecord::Migration[5.1]
  def change
    create_table :replies, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true

      t.text :content, null: false

      t.integer :upvote_count, null: false, default: 0
      t.integer :report_count, null: false, default: 0

      t.timestamps
    end
  end
end
