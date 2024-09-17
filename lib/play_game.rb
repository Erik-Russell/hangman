# frozen_string_literal: true

require 'json'
require_relative 'serialize'
require_relative 'dictionary'

# PlayGame - Create and control instance of a game of Hangman
class PlayGame
  include BasicSerialize
  attr_reader :word_to_guess, :correct_guesses, :wrong_guesses, :guesses

  def initialize
    @word_to_guess = []
    @correct_guesses = []
    @wrong_guesses = []
    @guesses = []
    @score = 0
    @guess = ''
    @choice = ''
  end

  # return randowm word as array of letters
  def new_word
    dictionary = Dictionary.new
    @word_to_guess = dictionary.dictionary[rand(dictionary.dictionary.count)].chars
    @correct_guesses = Array.new(@word_to_guess.length) { '_' }
    puts "The word is #{@word_to_guess.length} letters long"
  end

  # validate player guess
  def one_letter?(letter)
    true if letter.match?(/^[A-Za-z]{1}$/)
  end

  def only_letters?(word)
    true if word.match?(/\A[A-Za-z]*\z/)
  end

  def message_to_player
    puts "\n\n\n\n  #{@correct_guesses.join}"
    puts "wrong guesses: #{@wrong_guesses}" unless @wrong_guesses.empty?
    puts "\nTo save your game type 'save'"
    puts "To load a game type 'load'"
    puts 'To continue enter a letter as your guess'
  end

  def filename_set
    loop do
      puts 'enter filename'
      input = gets.chomp
      return input if only_letters?(input)
    end
  end

  def save_game
    save_file = serialize
    filename = "game_saves/#{filename_set}.json"
    File.open(filename, 'w') do |file|
      file.puts save_file
    end
    puts "file saved as #{filename}"
  end

  def load_game
    filename = "game_saves/#{filename_set}.json"

    unserialize(filename)
    puts "#{filename} loaded"
  end

  def save_load_handler(choice)
    Dir.mkdir('game_saves') unless Dir.exist?('game_saves')
    save_game if choice == 'save'
    load_game if choice == 'load'
    puts 'handled'
  end

  # get player guess
  def player_guess
    loop do
      @guess = @choice
      next if already_guessed?(@guess)

      @guesses.push(@guess)
      return @guess
    end
  end

  def already_guessed?(letter)
    return unless @guesses.include?(letter)

    puts 'you already used that letter'
    true
  end

  def correct?(guess)
    if @word_to_guess.include?(guess)
      @word_to_guess.each_with_index do |letter, index|
        @correct_guesses[index] = guess if letter == guess
      end
    else
      @wrong_guesses.push(guess).sort!
      puts 'wrong'
    end
  end

  def lose?
    return unless @wrong_guesses.length == 8

    puts "you lose, the word was #{@word_to_guess.join}"
    true
  end

  def player_turn
    return unless player_choice

    @guess = player_guess
    correct?(@guess)
    # puts
    # puts @correct_guesses.join
    # puts "wrong guesses: #{@wrong_guesses}"
    return true if lose?

    return unless @correct_guesses == @word_to_guess

    puts 'you win'
    true
  end

  def player_choice
    message_to_player
    @choice = gets.chomp.downcase
    if one_letter?(@choice)
      true
    elsif @choice == 'save' || @choice == 'load'
      puts 'here the file would save or load'
      save_load_handler(@choice)
    else
      puts 'invalid entry'
    end
  end
end
