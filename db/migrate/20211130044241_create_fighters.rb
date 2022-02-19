class CreateFighters < ActiveRecord::Migration[6.1]
  def change
    create_table :fighters do |t|
      t.string :name
      t.integer :health_point
      t.integer :attack
      t.integer :defence
      t.integer :speed_attack
      t.integer :level
      t.integer :experience
      t.string :stats_up_hash
      t.string :gear_stats_array, array: true, default: []

      t.timestamps
    end
  end
end
