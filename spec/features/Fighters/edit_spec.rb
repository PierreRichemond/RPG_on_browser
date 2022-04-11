require 'rails_helper'

RSpec.feature 'fighter\'s index' do
  before do
    @pikachu = Fighter.create(name: 'Pikachu', level: 4)
  end

  scenario 'show one fighter\'s details' do
    visit '/'
    click_link 'Hall of warriors'
    expect(page).to have_content('Pikachu')

    path = "/fighters/#{@pikachu.id}/edit"
    link = "a[href = \'#{path}\']"
    find(link).click
    expect(page).to have_content("Editing page of Pikachu")

    fill_in "Name", with: 'Tom'
    click_button "Edit your Warrior"
    expect(page).to have_content("Fighter's details has been updated")
    expect(page).to have_content('Tom')
    expect(page).not_to have_content('Pikachu')
    expect(page).to have_link('Delete')
    expect(page).to have_link('Edit')
    expect(page).not_to have_link('See more')

  end
end
