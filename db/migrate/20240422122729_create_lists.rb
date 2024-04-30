class CreateLists < ActiveRecord::Migration[7.1]
  def change
    create_table :lists do |t|
      t.string :name
      t.references :board, null: false, foreign_key: true
      t.float :position
      t.float :prev_position

      t.timestamps
    end
  end
end
