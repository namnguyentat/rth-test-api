class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :email
      t.text :title
      t.text :content

      t.timestamps
    end
  end
end
