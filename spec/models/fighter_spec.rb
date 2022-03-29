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
  end
end

RSpec.describe FighterService, :type => :service do
  describe '#create_fighter' do
    subject { fighter }
    let(:fighter) { FighterService.create_fighter('bob', nil) }

    it {expect(subject).to be_an_instance_of(Fighter)}
    it {expect(subject).to be_valid}
  end
end
