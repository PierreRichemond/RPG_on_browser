class AddStatsToFighter < ActiveRecord::Migration[6.1]
  def change
    add_column :fighters, :stats, :string
  end
end
