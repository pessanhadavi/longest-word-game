require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @score_hash = validate(@word, @letters)
  end

  def validate(word, letters)
    in_the_grid = in_the_grid?(word, letters)
    english_word = english_word?(word)
    overused_letters = overused_letters?(word, letters.join)
    { in_grid: in_the_grid, english_word: english_word, overused: overused_letters }
  end

  def in_the_grid?(word, letters)
    word.chars.all?(/[#{@letters.join.downcase}]/)
  end

  def english_word?(word)
    wagon_file = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    json = JSON.parse(wagon_file)
    json["found"]
  end

  def overused_letters?(word, letters)
    letters.upcase.chars.each do |letter|
      return true if word.upcase.chars.count(letter) > letters.count(letter)
    end
    false
  end
end
