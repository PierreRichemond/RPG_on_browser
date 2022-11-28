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
# switch_player
# calculate_player_damage(player, opponent)


require 'rails_helper'

RSpec.describe Fight, :type => :model do
  let(:fighter_1) { FighterService.create_fighter('Joe', nil) }
  let(:fighter_2) { FighterService.create_fighter('bobby', nil) }

  describe '#valid?' do
    it "is valid if fighters are different" do
      expect( FightService.new(fighter_1, fighter_2).fight ).to be_valid
    end
  end

  describe '#not_valid?' do
    it "is not valid without both fighter" do
      expect{ FightService.new(fighter_1).fight }.to raise_error(ArgumentError)
    end

    it "is not valid without a fighter" do
      expect{ FightService.new(nil, nil).fight }.to raise_error(NoMethodError)
    end

    it "is not valid if both are the same fighter" do
      expect( FightService.new(fighter_1, fighter_1).fight ).not_to be_valid
    end
  end
end
