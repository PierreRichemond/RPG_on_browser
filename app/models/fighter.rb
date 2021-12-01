class Fighter < ApplicationRecord
  has_one_attached :photo
  has_many :fightergears, dependent: :destroy
  has_many :gears, through: :fightergears
  has_many :fightfighters, dependent: :destroy
  has_many :fights, through: :fightfighters
  validates :name, uniqueness: true, presence: true
  # has_many gears
  # has_one_equiped gear
  @gear_pool = []

  def level_up
    self.level += 1
    stat_up
    gear = gear.all.sample
    gear_stats(gear)
    @gear_pool << FighterGear.create(self, gear)
  end

  def win_battle(opponent_level)
    self.experience += opponent_level * 10
    check_level_up
    gear = gear.all.sample
    @gear_pool << FighterGear.new(self, gear)
  end

  def lost_battle(opponent_level)
    self.experience += opponent_level * 2
    check_level_up
  end

  def experience_per_level
    level * 10
  end

  def check_level_up
    level_up if self.experience >= level * 10
  end

  def stat_up
    self.stats_up_array = []
    2.times do
      random_case = [1, 2, 3, 4].sample
       stats_up_array << "Hp +5" if random_case == 1
       stats_up_array << "Attack +2" if random_case == 2
       stats_up_array << "Defence +2" if random_case == 3
       stats_up_array << "Speed Attack +2" if random_case == 4
      case random_case
      when 1 then self.health_point += 5
      when 2 then self.attack += 2
      when 3 then self.defence += 2
      when 4 then self.speed_attack += 2
      end
    end
  end

  def gear_stats(gear)
    if gear.attack.present? && gear.defence.present? && gear.speed_attack.present?
      stats_up_array << "#{gear.name}, attack #{gear.attack}, defence #{gear.defence}, Speed attack#{-gear.speed_attack}"
    elsif gear.attack.present? && gear.speed_attack.present?
      stats_up_array << "#{gear.name}, attack #{gear.attack}, Speed attack#{-gear.speed_attack}"
    elsif gear.defence.present? && gear.speed_attack.present?
      stats_up_array << "#{gear.name}, attack #{gear.defence}, Speed attack#{-gear.speed_attack}"
    end
  end
end
