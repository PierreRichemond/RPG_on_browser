require 'rails_helper'

RSpec.feature 'fighter\'s show' do
  before do
    @pikachu = Fighter.create(name: 'Pikachu', level: 4, stats: { overall_stats: 32})
  end

  scenario 'one fighter\'s details' do
    visit '/'
    click_link 'Hall of warriors'
    click_link 'See more'

    expect(page).to have_content(@pikachu.name)
    expect(page).to have_content(@pikachu.level)
    expect(page).to have_content(@pikachu.stats[:overall_stats])
    expect(page).to have_content("#{@pikachu.name}'s gears")
    expect(page).to have_link('Delete')
    expect(page).to have_link('Edit')
    expect(page).not_to have_link('See more')

  end
end
