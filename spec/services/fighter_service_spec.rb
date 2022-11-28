require 'rails_helper'

RSpec.describe FighterService, :type => :service do
  describe '#create_fighter' do
    subject { FighterService.create_fighter('bob', nil) }

    it { should be_an_instance_of(Fighter) }
    it { should be_valid }
  end

  describe '#experience_per_level' do
    subject { FighterService.experience_per_level(level) }

    context 'when fighter is level 1' do
      let(:level) { 1 }
      it { should eq(10) }
    end

    context 'when fighter is level 5' do
      let(:level) { 5 }
      it { should eq(50) }
    end

    context 'when fighter is level 6' do
      let(:level) { 6 }
      it { should eq(90) }
    end

    context 'when fighter is level 10' do
      let(:level) { 10 }
      it { should eq(150) }
    end

    context 'when fighter is level 11' do
      let(:level) { 11 }
      it { should eq(220) }
    end

    context 'when fighter is level 15' do
      let(:level) { 15 }
      it { should eq(300) }
    end

    context 'when fighter is level 16' do
      let(:level) { 16 }
      it { should eq(400) }
    end

    context 'when fighter is level 19' do
      let(:level) { 19 }
      it { should eq(475) }
    end
  end

  context 'Check Fighter\'s experience gain' do
    let(:fighter_1) { FighterService.create_fighter('Joe', nil) }
    let(:fighter_2) { FighterService.create_fighter('bobby', nil) }

    describe '#number_of_level_taken' do
      describe 'for a level 1' do
        describe 'while getting the remaining amount' do
          let(:experience_to_next_level) { FighterService.experience_per_level(fighter_1.level) - fighter_1.experience}
          subject { FighterService.number_of_level_taken(fighter_1, 10)}
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
          let(:experience_to_next_level) { FighterService.experience_per_level(fighter_3.level) - fighter_3.experience }
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
    let!(:gear) { Gear.create!(name: "Ring", attack: 4, defence: 1, speed_attack: 1, level: 1) }
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

    describe '#get_gear' do
      subject { FighterService.get_gear(fighter_1) }
      it 'gets a random gear to the fighter' do
        expect { subject }.to change { [FighterGear.count, fighter_1.new_gear_stats_array.size] }.from([0, 0]).to([1, 1])
      end
    end

    describe '#stat_up' do
      it 'adds stats' do
        prev_overall_stats = fighter_1.stats[:overall_stats]
        fighter_1.stats_up_hash = {
          speed_attack: 0,
          attack: 0,
          defence: 0,
          hp: 0
        }
        FighterService.stat_up(fighter_1, 1)

        new_overall_stats = fighter_1.stats[:overall_stats]
        expect(new_overall_stats).to be > prev_overall_stats
      end
    end

    describe '#set_overall_stats' do
      it 'adds stats' do
        prev_stats = fighter_1.stats[:overall_stats]
        fighter_1.stats[:attack] = 10
        FighterService.set_overall_stats(fighter_1)
        new_stats = fighter_1.stats[:overall_stats]
        expect(new_stats).not_to eq(prev_stats)
         expect(new_stats).to be > prev_stats
      end
    end

    describe '#edit_character_stats' do
      it 'edits stats' do
        prev_stats = fighter_1.stats[:overall_stats]
        fighter_1.stats[:attack] = 10
        FighterService.edit_character_stats(fighter_1)
        new_stats = fighter_1.stats[:overall_stats]
        expect(new_stats).not_to eq(prev_stats)
        expect(new_stats).to be > prev_stats
      end
    end

    describe '#level_up' do
      it 'checks level up' do
        fighter_1.stats_up_hash = {
          speed_attack: 0,
          attack: 0,
          defence: 0,
          hp: 0
          }
        prev_level = fighter_1.level
        FighterService.level_up(fighter_1, 3)
        new_level = fighter_1.level
        expect(new_level).not_to eq(prev_level)
        expect(new_level).to be > prev_level
      end
    end
  end
end
