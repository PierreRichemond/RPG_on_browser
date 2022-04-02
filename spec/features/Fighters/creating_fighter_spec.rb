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
    expect(page).to have_content(fighter.name)

  end

  scenario "with invalid inputs" do
    fill_in 'Name', with: ''
    click_button 'Create a new Warrior'

   expect(page).to have_content("Fighter has not been created")
   expect(page).to have_content("Name date can't be blank")
  end
end
