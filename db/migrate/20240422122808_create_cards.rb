class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :description
      t.references :list, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.float :position
      t.float :prev_position

      t.timestamps
    end
  end
end
