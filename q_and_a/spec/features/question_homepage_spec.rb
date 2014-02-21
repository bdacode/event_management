require 'spec_helper'

feature 'Question' do 
  scenario "When the user visits the homepage" do
    visit "/"
    expect(page).to have_content("Ask a Question")
  end

  scenario "User can add a question" do
    visit "/"
    click_on "Ask Away"
    fill_in "Topic", with: "bacon recipes"
    fill_in "Question", with: "bacon and eggs?"
    click_on "Ask"
    expect(current_path).to eq("/")
  end

  scenario "User can see all questions that have been asked" do
    #Given
    create :question, topic: "bacon recipes", body: "bacon and eggs?"
    
    #When
    visit "/"

    #Then
    expect(page).to have_content("Topic: bacon recipes")
  end  
end