class QuestionsController < ApplicationController
  
  def index
    @questions = Question.all
    @num_questions = Question.total
  end

  def new

  end

  def create
    question = Question.new(question_params)
    if question.save
      redirect_to root_url, notice: "Thank you!"
    else
      flash.now[:error] = "Sorry, your question can not be added"
      render :new
    end
  end

  def show

  end

  private

  def question_params
    params.require(:question).permit(:topic, :body)
  end

end