require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    @answer = params[:answer].upcase
    @letters = params[:word]
    array = @answer.chars.select { |letter| @letters.chars.include?(letter) }
    if array.count != @answer.chars.count
      @result = "Not in the grid :/"
      @score = 0
    elsif get_json(@answer)["found"] == false
      @result = "Not english my friend"
      @score = 0
    else
      @result = "Well done buddy!"
      @score = @answer.chars.count * 10 / (Time.now - Time.parse(params[:start_time])).round(2)
    end
  end

  def get_json(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    serialized_grid = open(url).read
    result = JSON.parse(serialized_grid)
    return result
  end

end
