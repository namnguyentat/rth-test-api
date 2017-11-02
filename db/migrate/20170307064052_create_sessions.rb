class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true

      t.string :access_token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
