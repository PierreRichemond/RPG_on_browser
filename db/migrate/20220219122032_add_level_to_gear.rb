class AddLevelToGear < ActiveRecord::Migration[6.1]
  def change
    add_column :gears, :level, :integer
  end
end
