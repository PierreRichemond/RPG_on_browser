require 'rails_helper'

RSpec.feature 'Creating fighter' do

  before do
    visit '/'
    click_link 'Create a new character'
  end

  scenario 'with valid input' do
    fill_in 'Your fighter\'s name', with: 'Barbie'
    click_button 'Create a new Warrior'
    expect(page).to have_content('Fighter has been created')
    fighter = Fighter.last
    expect(current_path).to eq('/fighters')

    expect(fighter).to be_truthy
  end

  scenario "with invalid inputs" do
    fill_in 'Your fighter\'s name', with: ''
    click_button 'Create a new Warrior'

    fighter = Fighter.new(name: '')
    expect(fighter).not_to be_valid
    expect(page).to have_content("Fighter has not been created")
    expect(page).to have_content("Name can't be blank")
  end
end
