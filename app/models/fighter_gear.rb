class FighterGear < ApplicationRecord
  belongs_to :gear
  belongs_to :fighter

  def equiped!
    self.equiped = true
  end

  def unequiped!
    self.equiped = false
  end

  def is_equiped
    if equiped
      if self.gear.attack.present? && self.gear.defence.present? && self.gear.speed_attack.present?
        self.fighter.attack += self.gear.attack
        self.fighter.defence += self.gear.defence
        self.fighter.speed_attack += self.gear.speed_attack
      elsif self.gear.defence.present? && self.gear.speed_attack.present?
        self.fighter.defence += self.gear.defence
        self.fighter.speed_attack += self.gear.speed_attack
      elsif self.gear.attack.present? && self.gear.speed_attack.present?
        self.fighter.attack += self.gear.attack
        self.fighter.speed_attack += self.gear.speed_attack
      elsif self.gear.defence.present? && self.gear.attack.present?
        self.fighter.defence += self.gear.defence
        self.fighter.attack += self.gear.attack
      elsif self.gear.speed_attack.present?
        self.fighter.speed_attack += self.gear.speed_attack
      elsif self.gear.attack.present?
        self.fighter.attack += self.gear.attack
      elsif self.gear.defence.present?
        self.fighter.defence += self.gear.defence
      end
    end
  end
end
