require 'rails_helper'

RSpec.feature 'Listing homes basic features' do
  scenario 'Shows presence of links and h1' do
    visit '/'
    expect(page).to have_content('Welcome to the Arena!')
    expect(page).to have_link('Home')
    expect(page).to have_link('Hall of warriors')
    expect(page).to have_link('Create a new character')
  end
end
