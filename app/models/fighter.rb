# == Schema Information
#
# Table name: fighters
#
#  id                   :bigint           not null, primary key
#  experience           :integer
#  level                :integer
#  name                 :string
#  new_gear_stats_array :string           default([]), is an Array
#  stats                :string
#  stats_up_hash        :string
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
  #single table inheritance to create mage, priest, warriors, ninja...

  # ideas
  # def gear_attack
  #   @combined_attack ||= begin
  #     gear_attack = fighter.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.attack || 0 }.sum
  #     fighter.stats[:attack] + gear_attack
  #   end
  # end
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
