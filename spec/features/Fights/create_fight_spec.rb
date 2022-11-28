require 'rails_helper'

RSpec.feature 'Creating fight' do
  before do
    visit '/'
  end

  describe 'with valid input' do
    Fighter.create(name: 'Ken', level: 2, stats: {overall_stats: 25, health_point: 20, attack:12, defence:0, speed_attack:13})
    Fighter.create(name: 'Barbie', level: 1, stats: {overall_stats: 21, health_point: 20, attack:8, defence:0, speed_attack:13})

    it 'when both fighters are different' do
      find('#first-fighter').find('Barbie Power: 21').select_option
      find('#second-fighter', visible: false).find(:xpath, 'Ken Power: 25').select_option
      click_button 'Start a Fight'
      expect(page).to have_content('winner')
      fight = Fight.last
      expect(fight.winner.name).to eq('Ken')
      expect(current_path).to eq("/fight/#{fight.id}")
    end
  end

  describe "with invalid inputs" do
    Fighter.create(name: 'Ken', level: 2, stats: {overall_stats: 25, health_point: 20, attack:12, defence:0, speed_attack:13})
    Fighter.create(name: 'Barbie', level: 1, stats: {overall_stats: 21, health_point: 20, attack:8, defence:0, speed_attack:13})

    it 'when fighter is the same' do
      select "Barbie Power: 21", :from => "#first-fighter"
      select "Barbie Power: 21", :from => "#second-fighter"
      click_button 'Start a Fight'
      expect {page}.to raise_error
    end

    it 'when there is no fighter created' do
      select nil, :from => "#first-fighter"
      select nil, :from => "#second-fighter"
      click_button 'Start a Fight'
      expect{page}.to raise_error
    end
  end
end
