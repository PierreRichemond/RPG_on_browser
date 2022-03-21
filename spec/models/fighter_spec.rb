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

RSpec.describe Fighter do
# experience_per_level(level)
# check_level_up(fighter, received_experience)
# calculates_experience_from_fight(fighter, opponent, rate)

  describe '#experience_per_level' do
    subject { fighter.experience_per_level(level) }

    let(:fighter) do
      Fighter.new
    end

    context 'lose' do

      let(:level) {1}
      it 'gets 10 exp for level 1' do
        expect(subject).to eq(10)
      end
    end

    context 'win' do

    end
  end
end
