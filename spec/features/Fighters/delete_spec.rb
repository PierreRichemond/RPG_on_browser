
require 'rails_helper'

RSpec.feature 'fighter\'s index' do
  before do
    @pikachu = Fighter.create(name: 'Pikachu', level:4)
  end

  scenario 'show one fighter\'s details' do
    visit '/'
    click_link 'Hall of warriors'
    expect(page).to have_content('Pikachu')

    click_link 'See more'
    expect(page).to have_content('Editing page of Pikachu')

    path = "/fighters/#{@pikachu.id}"
    link = "//a[contains(@href, \'#{path}\') and .//text()='Destroy']"
    find(:xpath, link).click

    expect(page).to have_content("Fighter has been deleted properly")
  end

  end
end
