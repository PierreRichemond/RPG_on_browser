class CreateFights < ActiveRecord::Migration[6.1]
  def change
    create_table :fights do |t|
      t.references :red_fighter, null: false, foreign_key: { to_table: :fighters }
      t.references :blue_fighter, null: false, foreign_key: { to_table: :fighters }
      t.string :first_fighter
      t.string :second_fighter
      t.string :turns, array: true, default: []
      t.string :winner
      t.timestamps
    end
  end
end
