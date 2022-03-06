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
#
require "test_helper"

class FightTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
