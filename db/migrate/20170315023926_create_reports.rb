class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.references :reportable, polymorphic: true

      t.integer :kind, null: false, default: 0
      t.text :content

      t.timestamps
    end
  end
end
