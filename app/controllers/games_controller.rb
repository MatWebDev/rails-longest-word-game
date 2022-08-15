require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    @score = score_message(@word, @grid)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid_size.times { grid << ('A'..'Z').to_a.sample }
    grid
  end

  def match_grid(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def word_api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    dictionary = URI.open(url).read
    JSON.parse(dictionary)
  end

  def score_message(word, grid)
    if match_grid(word.upcase, grid) && word_api(word)['found']
      # score = word_api(word)["length"].fdiv(time)
      "Congratulations! #{word.upcase} is a valid English word!"
    elsif match_grid(word.upcase, grid) == false
      "Sorry but #{word.upcase} can't be built out of #{grid}"
    elsif word_api(word)['found'] == false
      "Sorry but #{word.upcase} does not seem to be a valid English word..."
    end
  end

  # def run_game(attempt, grid, start_time, end_time)
  #   # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
  #   time = end_time - start_time
  #   score_message = score_message(attempt, grid, time)
  #   {
  #     score: score_message[0],
  #     message: score_message[1],
  #     time: time
  #   }
  # end
end
