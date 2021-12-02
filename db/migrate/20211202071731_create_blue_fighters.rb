class CreateBlueFighters < ActiveRecord::Migration[6.1]
  def change
    create_table :blue_fighters do |t|
      t.references :fighter, null: false, foreign_key: true
      t.timestamps
    end
  end
end
