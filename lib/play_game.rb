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
    @turn = 0
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

  def start_message
    puts "To load a game type 'load'"
    puts "To play type 'play'"
  end

  def turn_message
    puts "\n\nEnter a letter as a guess or type 'save' to save your game"
    puts "\n\n  #{@correct_guesses.join}"
    puts "wrong guesses: #{@wrong_guesses}" unless @wrong_guesses.empty?
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
    files = Dir.entries('./game_saves').select { |f| File.file? File.join('./game_saves', f) }
    puts files
    filename = "game_saves/#{filename_set}.json"

    unserialize(filename)
    puts "#{filename} loaded"
  end

  def save_load_handler(choice)
    Dir.mkdir('game_saves') unless Dir.exist?('game_saves')
    save_game if choice == 'save'
    load_game if choice == 'load'
  end

  # get player guess
  def player_guess
    loop do
      turn_message
      input = gets.chomp
      save_load_handler(input) if input == 'save'
      next unless one_letter?(input)

      next if already_guessed?(input)

      @guess = input
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
    player_choice if @turn.zero?
    @turn = 1
    @guess = player_guess
    correct?(@guess)
    return true if lose?

    return unless @correct_guesses == @word_to_guess

    puts 'you win'
    true
  end

  def player_choice
    start_message
    @choice = gets.chomp.downcase
    if @choice == 'play'
      new_word
      true
    elsif @choice == 'load'
      puts 'choose one of the following saves:'
      save_load_handler(@choice)
    else
      puts 'invalid entry'
    end
  end
end
