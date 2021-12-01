class CreateGears < ActiveRecord::Migration[6.1]
  def change
    create_table :gears do |t|
      t.string :name
      t.integer :attack
      t.integer :defence
      t.integer :speed_attack

      t.timestamps
    end
  end
end
