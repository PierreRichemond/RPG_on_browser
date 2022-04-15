
require 'rails_helper'

RSpec.feature 'fighter\'s delete' do
  before do
    @pikachu = Fighter.create(name: 'Pikachu', level: 4)
  end

  scenario 'one fighter\'s details' do
    visit '/'
    click_link 'Hall of warriors'
    expect(page).to have_content('Pikachu')

    click_link 'See more'
    click_link "Delete"

    expect(page).to have_content("Fighter has been deleted properly")
  end
end
