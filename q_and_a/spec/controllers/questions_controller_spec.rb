require 'spec_helper'

describe QuestionsController do
  describe "#index" do
    it "is successful" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#create" do
    it "creates a new question" do
      expect do
        post :create, question: { topic: 'bacon recipes', body: 'bacon and eggs?'}
      end.to change {Question.count}.by(1)
    end 

    it "redirects to the homepage" do
      post :create, question: { topic: 'bacon recipes', body: 'bacon and eggs?'}
      expect(response).to redirect_to(root_url)
    end

    it "sets a thank you method in flash" do
      post :create, question: { topic: 'bacon recipes', body: 'bacon and eggs?'}
      expect(flash[:notice]).to be
    end
  end

  
end