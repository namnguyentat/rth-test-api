class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :actor, foreign_key: {to_table: :users}
      t.references :resource, polymorphic: true

      t.integer :status, null: false, default: 0
      t.integer :kind, null: false, default: 0
      t.integer :action, null: false, default: 0
      t.text :data

      t.timestamps
    end
  end
end
