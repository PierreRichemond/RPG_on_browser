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
require_relative "../../app/models/fighter.rb"

RSpec.describe Fighter do
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
  describe '#number_of_level_taken' do
    subject { fighter.number_of_level_taken(current_level, current_experience, received_experienced) }
    context 'lose' do
      context 'level 1 vs level 1 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 1) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(0) }
      end

      context 'level 1 vs level 5 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 5) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(1) }
      end

      context 'level 1 vs level 10 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 10) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(1) }
      end

      context 'level 1 vs level 15 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 15) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(2) }
      end

      context 'level 15 with almost all exp vs 15' do
        let(:fighter) { described_class.new(name: "Bob", level: 15, experience: 140) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 15, experience: 20) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(1) }
      end

      context 'level 15 with almost no exp vs 15' do
        let(:fighter) { described_class.new(name: "Bob", level: 15, experience: 20) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 15, experience: 20) }
        let(:current_level) { opponent.level * 2 }
        it { expect(subject).to eq(0) }
      end
    end

    context 'win' do
      context 'level 1 vs a level 1 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 1) }
        let(:current_level) { opponent.level * 10 }
        it { expect(subject).to eq(1) }
      end

      context 'level 1 vs a level 3 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 3) }
        let(:current_level) { opponent.level * 10 }
        it { expect(subject).to eq(2) }
      end

      context 'level 1 vs a level 6 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 6) }
        let(:current_level) { opponent.level * 10 }
        it { expect(subject).to eq(3) }
      end

      context 'level 1 vs a level 10 opponent' do
        let(:fighter) { described_class.new(name: "Bob", level: 1) }
        let(:current_level) { fighter.level }
        let(:current_experience) { 0 }
        let(:opponent) { described_class.new(name: "Pierre", level: 10) }
        let(:current_level) { opponent.level * 10 }
        it { expect(subject).to eq(4) }
      end
    end
  end
end
