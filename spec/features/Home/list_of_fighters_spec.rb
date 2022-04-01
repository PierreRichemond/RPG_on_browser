require 'rails_helper'

RSpec.feature 'Listing home\'s fighters' do
  before do
    @pikachu = Fighter.create(name: 'Pikachu', level:4, stats: {overall_stats: 32})
    @ryu = Fighter.create(name: 'Ryu', level:3, stats: {overall_stats: 27})
    @ken = Fighter.create(name: 'Ken', level:2, stats: {overall_stats: 25})
    @barbie = Fighter.create(name: 'Barbie', level:1, stats: {overall_stats: 21})
  end

  scenario 'the 3 strongest fighters' do
    visit '/'
    expect(page).to have_content('Our strongest challengers')
    expect(page).to have_content(@pikachu.name)
    expect(page).to have_content(@pikachu.level)
    expect(page).to have_content(@pikachu.stats[:overall_stats])

    expect(page).to have_content(@ryu.name)
    expect(page).to have_content(@ryu.level)
    expect(page).to have_content(@ryu.stats[:overall_stats])

    expect(page).to have_content(@ken.name)
    expect(page).to have_content(@ken.level)
    expect(page).to have_content(@ken.stats[:overall_stats])

    expect(page).not_to have_content(@barbie.name)
    expect(page).not_to have_content(@barbie.level)
    expect(page).not_to have_content(@barbie.stats[:overall_stats])

  end
end
