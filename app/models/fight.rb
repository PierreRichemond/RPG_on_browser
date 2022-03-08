# == Schema Information
#
# Table name: fights
#
#  id              :bigint           not null, primary key
#  first_fighter   :string
#  loser           :string
#  second_fighter  :string
#  turns           :string           default([]), is an Array
#  winner          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  blue_fighter_id :bigint           not null
#  red_fighter_id  :bigint           not null
#
# Indexes
#
#  index_fights_on_blue_fighter_id  (blue_fighter_id)
#  index_fights_on_red_fighter_id   (red_fighter_id)
#
# Foreign Keys
#
#  fk_rails_...  (blue_fighter_id => fighters.id)
#  fk_rails_...  (red_fighter_id => fighters.id)

#   -----------------------------------------

# TODO Ideas

# Fight
# fight_result  :string           serialize :fight_result, Hash
# fight_result = {
#   blue_fighter_id => {
#     won: true,
#     stats_up: stats_up_hash,
#     levels: 2
#   },
#   red_fighter_id => {
#     won: false,
#     stats_up: stats_up_hash,
#     levels: 0
#   }
# }

# Add history of fights
# fight 123 -> ken barbie
#   barbie leveled up
# fight 456 -> ken barbie
#   ken leveled up


# remove from Fight

#  winner           :string
#  loser           :string
#  first_fighter   :string
#  second_fighter   :string

# remove from Figther

#  stats_up: stats_up_hash

class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"
  validate :cant_fight_self

  def cant_fight_self
    if red_fighter == blue_fighter
      errors.add(:fight, 'Fighters has to be different.')
    end
  end
end
