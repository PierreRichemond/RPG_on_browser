class Fighter < ApplicationRecord
  has_one_attached :photo
  has_many :fighter_gears, dependent: :destroy
  has_many :gears, through: :fighter_gears
  has_many :fights_when_red, foreign_key: :red_fighter_id, dependent: :destroy, class_name: 'Fight'
  has_many :fights_when_blue, foreign_key: :blue_fighter_id, dependent: :destroy, class_name: 'Fight'
  validates :name, uniqueness: true, presence: true

  def level_up
    self.level += 1 #multiple level ?
    stat_up
    gear = Gear.all.sample
    gear_stats(gear)
    self.gears << gear
    self.experience -= (level - 1) * 10
  end

  def win_battle(opponent_level)
    self.experience += opponent_level * 10
    check_level_up
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

  def attack_with_gear
    gear_attack = self.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.attack || 0 }.sum
    attack + gear_attack
  end

  def defence_with_gear
    gear_defence = self.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.defence || 0 }.sum
    defence + gear_defence
  end

  def speed_attack_with_gear
    gear_speed_attack = self.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.speed_attack || 0 }.sum
    speed_attack + gear_speed_attack
  end


  def stat_up
    2.times do
      random_case = [1, 2, 3, 4].sample
      case random_case
      when 1
        self.health_point += 5
        stats_up_array << "Hp +5"
      when 2
        self.attack += 2
        stats_up_array << "Attack +2"
      when 3
        self.defence += 2
        stats_up_array << "Defence +2"
      when 4
        self.speed_attack += 3
        stats_up_array << "Speed Attack +4"
      end
    end
  end

  def gear_stats(gear)
    gear_stats_array = []
    if gear.attack.present? && gear.defence.present? && gear.speed_attack.present?
      gear_stats_array << "#{gear.name}, attack #{gear.attack}, defence #{gear.defence}, Speed attack #{gear.speed_attack}"
    elsif gear.attack.present? && gear.speed_attack.present?
      gear_stats_array << "#{gear.name}, attack #{gear.attack}, Speed attack #{gear.speed_attack}"
    elsif gear.defence.present? && gear.speed_attack.present?
      gear_stats_array << "#{gear.name}, attack #{gear.defence}, Speed attack #{gear.speed_attack}"
    end
  end
end
