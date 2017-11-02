class CreateUpvotes < ActiveRecord::Migration[5.1]
  def change
    create_table :upvotes, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :upvotable, polymorphic: true

      t.timestamps
    end
  end
end
