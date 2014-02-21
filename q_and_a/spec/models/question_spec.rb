require 'spec_helper'

describe Question do 
  it "exists" do
    expect(Question).to be
  end

  it "adds the total amount of questions" do
    create(:question, topic: "bacon recipes", body: "bacon and eggs?")
    create(:question, topic: "bacon recipes", body: "bacon and eggs?")    
    expect(Question.total).to eq(2)
  end

  describe "validations" do
    it "requires a topic" do
      question = build(:question, topic: nil)
      expect(question).to be_invalid
    end
    it "requires a body" do
      question = build(:question, body: nil)
      expect(question).to be_invalid
    end
  end

end