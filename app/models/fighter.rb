# == Schema Information
#
# Table name: fighters
#
#  id                   :bigint           not null, primary key
#  experience           :integer
#  level                :integer
#  name                 :string
#  new_gear_stats_array :string           default([]), is an Array
#  stats                :string           serialize :stats, Hash
#  stats_up_hash        :string           serialize :stats_up_hash, Hash
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
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

    @leveled_up = false
    @received_gear = false

    # received_gear? and leveled_up? return booleans value therefore
    # I prefer to keep the method here with a ? than a column in the DB
  def received_gear?
    @received_gear
  end

  def received_gear!
    @received_gear = true
  end

  def reset_received_gear
    # reset @received_gear to false each beginning of a fight
    @received_gear = false
  end

  def leveled_up?
    @leveled_up
  end

  def leveled_up!
    @leveled_up = true
  end

  def reset_leveled_up
    # reset @leveled_up to false each beginning of a fight
    @leveled_up = false
  end

  def experience_per_level
    # Experience a fighter needs to reach each level to level up
    if (1..3).includes?(level)
      (level * 10)
    elsif (4..10).includes?(level)
      (level * 10) * 1.5
    elsif (4..15).includes?(level)
      (level * 10) * 2
    else
      (level * 10) * 2.5
    end
  end

  def win_battle(opponent)
    # 30% chance of getting an item when winning on max level(20)
    return gears_on_level_max(30) if self.level == 20
    received_experience = calculates_experience_from_fight(opponent)
    check_level_up(received_experience)
  end

  def lost_battle(opponent)
    # 15% chance of getting an item when winning on max level(20)
    return gears_on_level_max(15) if self.level == 20
    received_experience = calculates_experience_from_fight(opponent)
    check_level_up(received_experience)
  end

  def calculates_experience_from_fight(opponent)
    #create a ratio of power difference between the fighters
    experience_ratio = opponent.stats[:overall_stats] / self.stats[:overall_stats].to_f
    # finds out the experience with the ratio
    received_experience = (opponent.level * 10) * experience_ratio
    # setup a minimum experience from a fight
    received_experience = 10 if received_experience <= 10
    received_experience
  end

  def gears_on_level_max(rate)
    if rate >= rand(0..100)
      get_gear
    end
  end

  def get_gear
    # find a gear having a level close from the fighter
    gear = Gear.all.select { |potential_gear| potential_gear.level <= self.level && potential_gear.level > self.level - 6 }.sample
    # assign the gear to the fighter
    FighterGear.create!(gear_id: gear.id, fighter_id: id, equiped: false)
    # when we get gear, have the received_gear? method returning true
    received_gear!
    #describe the gear's stats and store in in an array
    gear_stats(gear)
  end

  def check_level_up(received_experience)
    # add experience and return if no level up
    return self.experience += received_experience unless received_experience >= ((level * 10) - self.experience)
    # finds how many level the fighter gets for the fight
    number = number_of_level_taken(level, self.experience, received_experience)
    # when we get a level, have the leveled_up? method returning true
    leveled_up!
    # gives the fighter number of levels taken this fight
    level_up(number)
  end

  def number_of_level_taken(current_level, current_experience, received_experienced)
    #counts how many level the fighter gets
    count = 0
    experience_to_next_level = (current_level * 10) - current_experience
    while received_experienced >= experience_to_next_level
      received_experienced -= experience_to_next_level
      # when level up, the figther's experience gots to 0 to easily see the amount of experience he needs to get to the next level
      self.experience = 0
      # current_level is a value within the loop only, level gets up in level_up() method
      current_level += 1
      #counts keeps track of level numbers
      count += 1
      experience_to_next_level = (current_level * 10)
      #show 0 exp if we reach the top level
      received_experienced = 0 if current_level == 20
      # break loop when reaching level 20
      break if current_level == 20
    end
    self.experience = received_experienced
    count
  end

  def level_up(number)
    first_level_gained_this_fight = level + 1
    # add levels on the current level of the fighter
    self.level += number
    (first_level_gained_this_fight..self.level).each do |level_taken|
      # receive gear only on even level
      get_gear if level_taken.even?
    end
    number.times do
      # increase stats each level
      stat_up
    end
    # adjust the overall stats with the freshly received new stats
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
    attack = "#{gear.attack}" if gear.attack.present?
    defence = "#{gear.defence}" if gear.defence.present?
    speed_attack = "#{gear.speed_attack}" if gear.speed_attack.present?
    new_gear_stats_array << "#{gear.name}: ⚔ #{attack}, 🛡 #{defence}, 👟 #{speed_attack}, Gear level: #{gear.level}"
  end

  def stat_up
    2.times do
      case rand(4)
      when 0 then stats[:health_point] += 4; stats_up_hash[:hp] += 1
      when 1 then stats[:attack] += 2; stats_up_hash[:attack] += 1
      when 2 then stats[:defence] += 2; stats_up_hash[:defence] += 1
      when 3 then stats[:speed_attack] += 2; stats_up_hash[:speed_attack] += 1
      end
    end
    edit_character_stats
    set_overall_stats
  end

  def set_overall_stats
    if stats != {}
      stats[:overall_stats] = stats[:gear_speed_attack] + stats[:gear_attack] + stats[:gear_defence] + stats[:health_point] + stats[:intelligence] + stats[:regen]
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
# players have objects, limit of 20
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
