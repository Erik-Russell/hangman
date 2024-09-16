# frozen_string_literal: true

require_relative 'play_game'

filepath = 'google-10000-english-noswears.txt'

puts "Let's play a game of hangman!!!\n\n"

game_over = false

game = PlayGame.new
game.load_dictionary(filepath)
game.new_word
game_over = game.player_turn until game_over
