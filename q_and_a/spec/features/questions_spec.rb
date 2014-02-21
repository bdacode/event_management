require 'spec_helper'

feature 'Questions' do 
  scenario "A user fails to fill out the question form" do
    visit "/"
    click_on "Ask Away"
    fill_in "Topic", with: " "
    fill_in "Question", with: " "
    click_on "Ask"
    expect(page).to have_selector('.alert-danger')
  end
end