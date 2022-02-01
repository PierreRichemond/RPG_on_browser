class FighterGear < ApplicationRecord
  belongs_to :gear
  belongs_to :fighter

  validate :number_of_gear_equiped_lower_than_two

  def number_of_gear_equiped_lower_than_two
    FighterGear.where(fighter: fighter, equiped: true).count < 2
    # Fighter.where(fighter_gears: fighter, equiped: true).count
  end
end
