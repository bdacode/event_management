class Question < ActiveRecord::Base
  # validates_presence_of :topic, :body 
  validates :topic, presence: true
  validates :body,  presence: true

  def self.total
    total = Question.count
  end
end
