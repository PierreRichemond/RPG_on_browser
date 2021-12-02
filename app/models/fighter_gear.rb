class FighterGear < ApplicationRecord
  belongs_to :gear
  belongs_to :fighter

  validate :number_of_gear_equiped_lower_than_two?
  # my_item.update(equiped: true)

  def number_of_gear_equiped_lower_than_two?
    FighterGear.where(fighter: fighter, equiped: true).count < 2
  end
end
