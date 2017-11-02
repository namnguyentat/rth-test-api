class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :bookmarkable, polymorphic: true

      t.timestamps
    end
  end
end
