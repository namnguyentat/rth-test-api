class CreateFollows < ActiveRecord::Migration[5.1]
  def change
    create_table :follows, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :followable, polymorphic: true

      t.timestamps
    end
  end
end
