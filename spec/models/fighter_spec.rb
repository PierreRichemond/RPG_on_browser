
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
# describe '#level_up' do
#   subject { fighter.level_up(number) }

#   let(:fighter) { described_class.new(name: "Bob", level: 1) }

#   context 'takes one level' do
#     let(:number) { 1 }
#     it { expect(subject).to add number level to the fighter }
#     # fighter.level = 2
#     it { expect(subject).to add number gear to the fighter.gears }
#     # fighter.gears.count = 1
#   end
# end

require 'rails_helper'

RSpec.describe Fighter, :type => :model do
  context 'Check validations' do
    it "is valid with valid attributes" do
      expect(Fighter.new(name: 'bob', level: 1)).to be_valid
    end

    it "is not valid without a name" do
      fighter = Fighter.new(name: nil)
      expect(fighter).to_not be_valid
    end

    it "is not valid without a level" do
      fighter = Fighter.new(level: nil)
      expect(fighter).to_not be_valid
    end
  end
end

RSpec.describe FighterService, :type => :service do
  describe '#create_fighter' do
    subject { fighter }
    let(:fighter) { FighterService.create_fighter('bob', nil) }

    it {expect(subject).to be_an_instance_of(Fighter)}
    it {expect(subject).to be_valid}
  end

   context 'Check Fighter\'s experience gain' do
    let(:fighter_1) { FighterService.create_fighter('Joe', nil) }
    let(:fighter_2) { FighterService.create_fighter('bobby', nil) }
    describe '#experience_per_level' do

      describe 'level 1' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level) }
        it { expect(exp_needed).to eq(10) }
      end

      describe 'level 5' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+4) }
        it {expect(exp_needed).to eq(50)}
      end

      describe 'level 6' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+5) }
        it {expect(exp_needed).to eq(90)}
      end

      describe 'level 10' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+9) }
        it {expect(exp_needed).to eq(150)}
      end

      describe 'level 11' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+10) }
        it {expect(exp_needed).to eq(220)}
      end

      describe 'level 15' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+14) }
        it {expect(exp_needed).to eq(300)}
      end

      describe 'level 16' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+15) }
        it {expect(exp_needed).to eq(400)}
      end

      describe 'level 19' do
        let(:exp_needed) { FighterService.experience_per_level(fighter_1.level+18) }
        it {expect(exp_needed).to eq(475)}
      end
    end

    describe '#number_of_level_taken' do
      describe 'for a level 1' do
        describe 'while getting the remaining amount' do
          let(:experience_to_next_level) { FighterService.experience_per_level(fighter_1.level) - fighter_1.experience}
          subject { FighterService.number_of_level_taken(fighter_1, experience_to_next_level)}
          it {expect(subject).to eq(1)}
        end

        describe 'for getting just over 1 level' do
          subject { FighterService.number_of_level_taken(fighter_1, 15)}
          it {expect(subject).to eq(1)}
        end

        describe 'for getting just over 2 level' do
          subject { FighterService.number_of_level_taken(fighter_1, 30)}
          it {expect(subject).to eq(2)}
        end

        describe 'for getting 5 levels' do
          subject { FighterService.number_of_level_taken(fighter_1, 200)}
          it {expect(subject).to eq(5)}
        end
      end

      describe 'for a level 5' do
        let(:fighter_3) { Fighter.new(name: 'name', level: 5, experience: 0) }
        describe 'while getting the remaining amount' do
          let(:experience_to_next_level) { FighterService.experience_per_level(fighter_3.level) - fighter_3.experience}
          subject { FighterService.number_of_level_taken(fighter_3, experience_to_next_level)}
          it {expect(subject).to eq(1)}
        end

        describe 'not level up if not getting enough' do

          subject { FighterService.number_of_level_taken(fighter_3, 15)}
          it {expect(subject).to eq(0)}
        end

        describe 'for getting just over 1 level' do
          subject { FighterService.number_of_level_taken(fighter_3, 70)}
          it {expect(subject).to eq(1)}
        end

        describe 'for getting 2 level' do
          subject { FighterService.number_of_level_taken(fighter_3, 200)}
          it {expect(subject).to eq(2)}
        end

        describe 'for getting 3 level when already has experience' do
          let(:fighter_3) { Fighter.new(name: 'name', level: 5, experience: 45) }
          subject { FighterService.number_of_level_taken(fighter_3, 200)}
          it {expect(subject).to eq(3)}
        end
      end
    end
    describe '#calculates_experience_from_fight' do
      let(:fighter_3) { Fighter.new(name: 'name', level: 5, stats: {overall_stats: 60}) }
      let(:fighter_4) { Fighter.new(name: 'namo', level: 1, stats: {overall_stats: 30}) }

      describe 'for a' do
        describe 'level 1 wins to a level 1' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_1, fighter_2, 10)).to eq(10)}
        end
        describe 'level 1 wins to a level 5' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_4, fighter_3, 10)).to eq(100)}
        end
        describe 'level 5 wins to a level 1' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_3, fighter_4, 10)).to eq(5)}
        end
      end

      describe 'for a' do
        describe 'level 1 loses to a level 1' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_1, fighter_2, 2)).to eq(2)}
        end
        describe 'level 1 loses to a level 5' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_4, fighter_3, 2)).to eq(20)}
        end
        describe 'level 5 loses to a level 1' do
          it {expect(FighterService.calculates_experience_from_fight(fighter_3, fighter_4, 2)).to eq(1)}
        end
      end
    end
  end

  context 'gears' do
    let(:gear) { Gear.create!(name: "Ring", attack: 4, defence: 1, speed_attack: 1, level: 2)}
    let(:fighter_1) { FighterService.create_fighter('Joe', nil) }
    let(:fighter_2) { FighterService.create_fighter('bobby', nil) }

    describe '#gear_stats' do
      subject {FighterService.gear_stats(fighter_1, gear)}
      it 'adds in the new_gear_stats_array' do
        expect{subject}.to change { fighter_1.new_gear_stats_array.length }.by(1)
      end
    end

    describe '#unequiped_all' do
      subject {FighterService.unequiped_all(fighter_1)}
      let(:unequiped) { FighterGear.where(fighter: fighter_1, equiped: false).count}
      it {expect(subject).to eq(unequiped)}
    end

    # describe '#get_gear' do
    #   subject {FighterService.get_gear(fighter_1, gear)}
    #   it 'gets a random gear to the fighter' do
    #     expect{subject}.to change { fighter_1.new_gear_stats_array.length }.by(1)
    #   end
    # end


    # describe '#stat_up' do
    #   let(:fighter_1) { Fighter.new(name: 'Joe') }
    #   it 'adds stats' do
    #     fighter_1.stats = {attack: 0, defence: 0, health_point: 0, speed_attack: 0, overall_stats: 0, gear_attack: 0, gear_defence: 0, gear_speed_attack: 0}
    #     prev_stats = fighter_1.stats
    #     subject { FighterService(fighter_1, 1)}
    #     expect(fighter_1.stats).not_to eq(prev_stats)
    #   end
    # end

    # describe '#set_overall_stats' do
    #   let(:fighter_1) { Fighter.new(name: 'Joe') }
    #   it 'adds stats' do
    #     fighter_1.stats = {attack: 2, defence: 0, health_point: 0, speed_attack: 0, overall_stats: 0, gear_attack: 0, gear_defence: 0, gear_speed_attack: 0}
    #     prev_stats = fighter_1.stats
    #     subject { FighterService.set_overall_stats(fighter_1)}
    #     expect(fighter_1.stats).not_to eq(prev_stats)
    #   end
    # end

    # describe '#edit_character_stats' do
    #   it 'edits stats' do
    #     fighter_1.stats = {attack: 0, defence: 0, health_point: 0, speed_attack: 0, overall_stats: 0}
    #     prev_stats = fighter_1.stats
    #     expect(fighter_1.stat_up).not_to eq(prev_stats)
    #   end
    # end

    # describe '#level_up' do
      # is calling #get_gear
      # is calling #set_overall_stats
    # end
  end
end
