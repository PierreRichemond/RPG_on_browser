# == Schema Information
#
# Table name: fighter_gears
#
#  id         :bigint           not null, primary key
#  equiped    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fighter_id :bigint           not null
#  gear_id    :bigint           not null
#
# Indexes
#
#  index_fighter_gears_on_fighter_id  (fighter_id)
#  index_fighter_gears_on_gear_id     (gear_id)
#
# Foreign Keys
#
#  fk_rails_...  (fighter_id => fighters.id)
#  fk_rails_...  (gear_id => gears.id)
#
class FighterGear < ApplicationRecord
  belongs_to :gear
  belongs_to :fighter

  validate :number_of_gear_equiped_lower_than_two

  def number_of_gear_equiped_lower_than_two
     if FighterGear.where(fighter: fighter, equiped: true).count > 1
        errors.add(:fighter_gear, 'Only 2 gears can be equiped.')
     end
  end
end
