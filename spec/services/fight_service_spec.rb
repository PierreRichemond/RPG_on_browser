require 'rails_helper'

RSpec.describe FightService, :type => :service do
  let!(:fighter_1) { FighterService.create_fighter('Bob', nil) }
  let!(:fighter_2) { FighterService.create_fighter('Joe', nil) }
  subject { FightService.new(fighter_1, fighter_2).fight }

  describe '#valid' do
    it { should be_an_instance_of(Fight) }
    it { should be_valid }
  end

  # describe '#calculate_player_damage' do
  #   it "a strong player" do
  #     fighter_1.stats[:gear_speed_attack] = 3
  #     fighter_1.stats[:gear_attack] = 10
  #     fighter_1.stats[:gear_defence] = 5
  #     fighter_2.stats[:gear_speed_attack] = 2
  #     fighter_2.stats[:gear_attack] = 6
  #     fighter_2.stats[:gear_defence] = 2

  #     it expect(subject.calculate_player_damage(fighter_1, fighter_2)).to eq(5)
  #     it expect(subject.calculate_player_damage(fighter_2, fighter_1)).to eq(5)
  #   end
  # end
end
