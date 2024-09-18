# frozen_string_literal: true

require_relative 'play_game'

puts "Let's play a game of hangman!!!\n\n"
wants_to_play = true
game_over = false

if wants_to_play
  loop do
    game = PlayGame.new
    game_over = game.player_turn until game_over
    puts 'Do you want to play again?'
    input = gets.chomp
    break if input == 'no'

    game_over = false
  end
end
