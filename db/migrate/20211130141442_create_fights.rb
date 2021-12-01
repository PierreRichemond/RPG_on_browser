class CreateFights < ActiveRecord::Migration[6.1]
  def change
    create_table :fights do |t|
      t.string :first_fighter
      t.string :second_fighter

      t.timestamps
    end
  end
end
