class Fighter < ApplicationRecord
  has_one_attached :photo
  has_many :fighter_gears, dependent: :destroy
  has_many :gears, through: :fighter_gears
  has_many :fights_when_red, foreign_key: :red_fighter_id, dependent: :destroy, class_name: 'Fight'
  has_many :fights_when_blue, foreign_key: :blue_fighter_id, dependent: :destroy, class_name: 'Fight'
  validates :name, uniqueness: true, presence: true
  serialize :stats, Hash

  def experience_per_level
    level * 10
  end

  def win_battle(opponent_level)
    received_experience = opponent_level * 10
    check_level_up(received_experience)
  end

  def lost_battle(opponent_level)
    received_experience = opponent_level * 2
    check_level_up(received_experience)
  end

  def check_level_up(received_experience)
    return experience += received_experience unless received_experience >= ((level * 10) - experience)

    number = number_of_level_taken(level, experience, received_experience)
    level_up(number)
  end

  def number_of_level_taken(current_level, current_experience, received_experienced)
    count = 0
    experience_to_next_level = (current_level * 10) - current_experience
    while received_experienced >= experience_to_next_level
      received_experienced -= experience_to_next_level
      current_experience = 0
      current_level += 1
      count += 1
    end
    experience = received_experienced
    count
  end

  def level_up(number)
    level += number
    number.times do
      stat_up
      gears << gear = Gear.all.sample
      gear_stats(gear)
    end
    set_overall_stats
  end

  def edit_stats_on_gear_equiped
    gear_attack = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.attack || 0 }.sum
    @stats[:gear_attack] = @stats[:attack] + gear_attack
    gear_defence = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.defence || 0 }.sum
    @stats[:gear_defence] = @stats[:defence] + gear_defence
    gear_speed_attack = fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.speed_attack || 0 }.sum
    @stats[:gear_speed_attack] = @stats[:speed_attack] + gear_speed_attack
    set_overall_stats
  end

  def gear_stats(gear)
    attack = "Attack: #{gear.attack}" if gear.attack.present?
    defence = "Defence: #{gear.defence}" if gear.defence.present?
    speed_attack = "Speed Attack: #{gear.speed_attack}" if gear.speed_attack.present?
    gear_stats_array << "#{gear.name}," + attack + defence + speed_attack
  end

  def stat_up
    2.times do
      case rand(3)
      when 0 then @stats[:health_point] += 4; stats_up_array << "Hp +30"
      when 1 then @stats[:attack] += 2; stats_up_array << "Attack +2"
      when 2 then @stats[:defence] += 2; stats_up_array << "Defence +2"
      when 3 then @stats[:speed_attack] += 2; stats_up_array << "Speed Attack +4"
      end
    end
  end

  def set_overall_stats
    if stats != {}
    stats[:overall_stats] = stats[:gear_speed_attack] + stats[:gear_attack] + stats[:gear_defence]
    + stats[:health_point] + stats[:intelligence] + stats[:regen]
    end
  end
end


# TODO
# top level => 20
# Refacto stats into a hash
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
# change item winning system only even-level, and 20% chance to get one when winning
# item per level, unlock per level ; a lvl 2 cant get a grenade ...
# get an item within [lvl-6..level]
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
# #
