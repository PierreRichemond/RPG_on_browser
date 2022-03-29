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

  context 'Check validations' do
    it "is not valid without both fighter" do
      subject {Fight.new(fighter_1)}
      expect(subject).to_not be_valid
    end

    it "is not valid without a fighter" do
      fighter = Fight.new
      expect(fighter).to_not be_valid
    end

    it "is not valid if both are the same fighter" do
      subject {Fight.new(fighter_1, fighter_1)}
      expect(subject).to_not be_valid
    end

    # it "is valid if fighters are different" do
    #   subject {Fight.create!(red_fighter: fighter_1, blue_fighter: fighter_2)}
    #   expect(subject).to be_valid
    # end
  end

  # context '#calculate_player_damage' do

  #   describe "a strong player" do
  #     fighter_1.stats[gear_speed_attack] = 3
  #     fighter_1.stats[gear_attack] = 10
  #     fighter_1.stats[gear_defence] = 5
  #     fighter_2.stats[gear_speed_attack] = 2
  #     fighter_2.stats[gear_attack] = 6
  #     fighter_2.stats[gear_defence] = 2

  #     it expect(calculate_player_damage(fighter_1, fighter_2)).to eq(5)
  #     it expect(calculate_player_damage(fighter_2, fighter_1)).to eq(5)
  #   end
  # end
end
