class FighterGear < ApplicationRecord
  belongs_to :gear
  belongs_to :fighter

  # def equiped?
  #   false
  # end

  # def active_toogle
  #   self.equiped? = true
  # end
end
