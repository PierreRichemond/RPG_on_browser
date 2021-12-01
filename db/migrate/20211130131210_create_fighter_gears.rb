class CreateFighterGears < ActiveRecord::Migration[6.1]
  def change
    create_table :fighter_gears do |t|
      t.references :gear, null: false, foreign_key: true
      t.references :fighter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
