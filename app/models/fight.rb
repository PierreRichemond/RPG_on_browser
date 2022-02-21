class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"
  validate :cant_fight_self

  def cant_fight_self
    if red_fighter == blue_fighter
      errors.add(:fight, 'One fighter can\'t fight itself.')
    end
  end
end
