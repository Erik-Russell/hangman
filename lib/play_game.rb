# frozen_string_literal: true

# PlayGame - Create and control instance of a game of Hangman
class PlayGame
  attr_reader :word_to_guess

  def initialize
    @word_to_guess = []
    @correct_guesses = []
    @wrong_guesses = []
    @guesses = []
    @score = 0
    @dictionary = []
    @guess = ''
  end

  # load dictionary with word between 5 and 12 chars long
  def load_dictionary(file)
    File.foreach(file) do |line|
      @dictionary << line.strip if line.chomp.length.between?(5, 12)
    end
  end

  # return randowm word as array of letters
  def new_word
    @word_to_guess = @dictionary[rand(@dictionary.count)].chars
    @correct_guesses = Array.new(@word_to_guess.length) { '_' }
    puts "The word is #{@word_to_guess.length} letters long"
  end

  # validate player guess
  def one_letter?(letter)
    true if letter.match?(/^[A-Za-z]{1}$/)
  end

  # get player guess
  def player_guess
    loop do
      puts 'Please enter a single letter (a-z)'
      input = gets.chomp
      next unless one_letter?(input)

      @guess = input
      next if already_guessed?(@guess)

      @guesses.push(input)
      return input
    end
  end

  def already_guessed?(letter)
    true if @guesses.include?(letter)
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
    @guess = player_guess
    correct?(@guess)
    puts
    puts @correct_guesses.join
    puts "wrong guesses: #{@wrong_guesses}"
    return true if lose?

    return unless @correct_guesses == @word_to_guess

    puts 'you win'
    true
  end
end
