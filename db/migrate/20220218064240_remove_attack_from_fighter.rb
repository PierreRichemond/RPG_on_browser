class RemoveAttackFromFighter < ActiveRecord::Migration[6.1]
  def change
    remove_column :fighters, :attack, :integer
    remove_column :fighters, :health_point, :integer
    remove_column :fighters, :defence, :integer
    remove_column :fighters, :speed_attack, :integer
  end
end
