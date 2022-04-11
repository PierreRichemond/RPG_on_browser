
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
  describe '#valid?' do
    subject { Fighter.new(name: name, level: level) }

    context "when attributes are valid" do
      let(:name) { 'bob' }
      let(:level) { 1 }
      it { should be_valid }
    end

    context "when name is invalid" do
      let(:name) { nil }
      let(:level) { 1 }
      it { should_not be_valid }
    end

    context "when level is invalid" do
      let(:name) { 'bob' }

      context "when level is not present" do
        let(:level) { nil }
        it { should_not be_valid }
      end

      context "when level is higher than 20" do
        let(:level) { 21 }
        it { should_not be_valid }
      end

      context "when level is not an integer" do
        let(:level) { 5.5 }
        it { should_not be_valid }
      end
    end
  end
end
