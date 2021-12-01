class CreateFightfighters < ActiveRecord::Migration[6.1]
  def change
    create_table :fightfighters do |t|
      t.references :fight, null: false, foreign_key: true
      t.references :fighter, null: false, foreign_key: true
      t.string :turns, array: true, default: []
      t.string :winner

      t.timestamps
    end
  end
end
