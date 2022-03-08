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

  # fighter.fighter_gears.sort_by_level
  # Retrieve all fighter gear for fighter id 1 with order by gear level
  scope :sort_by_level, -> do
    includes(:gear).order('gears.level asc')
  end
  # This scope does this SQL request
  # FighterGear.execute_sql("SELECT * FROM FighterGear as fighter_gear JOIN Gear as gear WHERE gear.id = fighter_gear.gear_id AND fighter_gear.fighter_id = 1 ORDER gear.level");

  validate :number_of_gear_equiped_lower_than_two

  def number_of_gear_equiped_lower_than_two
    if FighterGear.where(fighter: fighter, equiped: true).count > 2
      errors.add(:fighter_gear, 'Only 2 gears can be equiped.')
    end
  end
end
