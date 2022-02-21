class Fighter < ApplicationRecord
  has_one_attached :photo
  has_many :fighter_gears, dependent: :destroy
  has_many :gears, through: :fighter_gears
  has_many :fights_when_red, foreign_key: :red_fighter_id, dependent: :destroy, class_name: 'Fight'
  has_many :fights_when_blue, foreign_key: :blue_fighter_id, dependent: :destroy, class_name: 'Fight'
  validates :name, uniqueness: true, presence: true
  validates :level, numericality: { less_than_or_equal_to: 20, only_integer: true }
  serialize :stats, Hash
  serialize :stats_up_hash, Hash
  #single table inheritance

  def experience_per_level
    level * 10
  end

  def win_battle(opponent_level)
    # 30%chance of wwinning a new item if winning
    return gears_on_level_max(30) if self.level == 20
    received_experience = opponent_level * 10
    check_level_up(received_experience)
  end

  def lost_battle(opponent_level)
    # 15% chance of wwinning a new item if winning
    return gears_on_level_max(15) if self.level == 20
    received_experience = opponent_level * 2
    check_level_up(received_experience)
  end

  def gears_on_level_max(rate)
    if rand(0..100) <= rate
      get_gear
    end
  end

  def get_gear
    gears << gear = Gear.all.select { |potential_gear| potential_gear.level <= self.level && potential_gear.level > self.level - 6 }.sample
    gear_stats(gear)
  end

  def check_level_up(received_experience)
    return self.experience += received_experience unless received_experience >= ((level * 10) - self.experience)

    number = number_of_level_taken(level, self.experience, received_experience)
    level_up(number)
  end

  def number_of_level_taken(current_level, current_experience, received_experienced)
    count = 0
    return count if current_level == 20
    experience_to_next_level = (current_level * 10) - current_experience
    while received_experienced >= experience_to_next_level
      received_experienced -= experience_to_next_level
      current_experience = 0
      current_level += 1
      count += 1
      received_experienced = 0 if current_level == 20
      break if current_level == 20
    end
    self.experience = received_experienced
    count
  end

  def level_up(number)
    level_before_fight = level
    self.level += number
    # receive gear only on even level
    (level_before_fight..self.level).each do |level_taken|
      if level_taken.even?
        get_gear
      end
    end
    number.times do
      stat_up
    end
    set_overall_stats
  end

  def edit_character_stats
    gear_attack = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.attack || 0 }.sum
    stats[:gear_attack] = stats[:attack] + gear_attack
    gear_defence = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.defence || 0 }.sum
    stats[:gear_defence] = stats[:defence] + gear_defence
    gear_speed_attack = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.speed_attack || 0 }.sum
    stats[:gear_speed_attack] = stats[:speed_attack] + gear_speed_attack
    set_overall_stats
  end

  def gear_stats(gear)
    attack = "Attack: #{gear.attack}" if gear.attack.present?
    defence = "Defence: #{gear.defence}" if gear.defence.present?
    speed_attack = "Speed Attack: #{gear.speed_attack}" if gear.speed_attack.present?
    gear_stats_array << "#{gear.name}: ⚔ #{attack}, 🛡 #{defence}, 👟 #{speed_attack}"
  end

  def stat_up
    2.times do
      case rand(3)
      when 0 then stats[:health_point] += 4; stats_up_hash[:hp] += 1
      when 1 then stats[:attack] += 2; stats_up_hash[:attack] += 1
      when 2 then stats[:defence] += 2; stats_up_hash[:defence] += 1
      when 3 then stats[:speed_attack] += 2; stats_up_hash[:speed] += 1
      end
    end
    edit_character_stats
    set_overall_stats
  end

  def set_overall_stats
    if stats != {}
      stats[:overall_stats] = stats[:gear_speed_attack] + stats[:gear_attack] + stats[:gear_defence]
      + stats[:health_point] + stats[:intelligence] + stats[:regen]
    end
  end
end


# TODO
# top level => 20   ==========================> OK
# Refacto stats into a hash    ==============================+>  ok
# refacto item stats into a hash


# stats = { attack = '',
#           defence = '',
#           speed_attack = '',
#           health_point = '',
#           dodge_rate = '',
#           hitting_rate = '',
#           intelligence = '',
          # spell_resistance = ''
#           regen = ''
# }

# ------------objects-------------
# players have objects, limit of 20 ====================++> OK
# potions, scrolls ect


# ------------- gear categories-----------
# change item winning system only even-level, and 20% chance to get one when winning ===========> ok
# item per level, unlock per level ; a lvl 2 cant get a grenade ... ====================>   OK
# get an item within [lvl-6..level]   ===========================> ok
# increase number of items
# weapon or clothes

# ---------------fighters ----------------
# ------weapon_user ; warrior and an archer-----
# 1/2 weapon / 1 shield / 1 bow, 5clothes(gloves, shoes, pants, shirt, head)
# weapon_user have energy and does regular kick when no more energy
# energy regenerate over turns depending on regen_ability
# life regenerate over turns depending on regen_ability
# 2; + 1 attack every 2 level, TOTAL 4 attacks


# casters ; mage and priest
# caster can have 1 weapon, 5clothes(gloves, shoes, pants, shirt, head)
# caster have spells and regular kick when no more mana
# mana regenerate over turns depending on regen_ability
# life regenerate over turns depending on regen_ability
# 2; + 1 attack every 2 level, TOTAL 4 attacks


# ------------------------HTML---------------------
# need one more view for the fight
# fight is a turn by turn where we have the option to :
#   - choose an attack amongst 2; + 1 attack every 2 level, TOTAL 4 attacks
#   - use an item to boost ourselves or deminish the opponent s stats
#   - run away ; meaning loosing

# change the New form to create a fighter with specificity
#   - mage / priest / warrior / archer
# '⚔️🛡👟'
