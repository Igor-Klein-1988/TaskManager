class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :author, foreign_key: { to_table: :users }
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :state, null: false
      t.datetime :expired_at

      t.timestamps
    end
  end
end
