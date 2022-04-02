require 'rails_helper'

RSpec.feature 'Creating fighter' do

  before do
    visit '/'
    click_link 'Create new character'
  end

  scenario 'with valid input' do
    fill_in 'Name', with: 'Barbie'
    click_button 'Create a new Warrior'
    expect(page).to have_content('Fighter has been created')
    fighter = Fighter.last
    expect(current_path).to eq('/fighters')

    it 'ensure creation of fighter' do
      expect(fighter).to be_truthy
    end

  end

  scenario "with invalid inputs" do
    fill_in 'Name', with: ''
    click_button 'Create a new Warrior'

    it 'ensure creation of fighter' do
      fighter = Fighter.new(name: '')
      expect(fighter).to be(false)
    end
   expect(page).to have_content("Fighter has not been created")
   expect(page).to have_content("Name date can't be blank")
  end
end
