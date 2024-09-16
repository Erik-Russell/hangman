# frozen_string_literal: true

# load dictionary with word between 5 and 12 chars long
dictionary = []
File.foreach('google-10000-english-noswears.txt') do |line|
  dictionary << line.strip if line.chomp.length.between?(5, 12)
end

# return randowm word as array of letters
def get_random_word(dictionary)
  dictionary[rand(dictionary.count)].split('')
end

def player_guess
  loop do
    puts 'please enter a letter as a guess'
    input = gets.chomp
    return input if input.match?(/^[A-Za-z]{1}$/)

    puts 'Invalid input! Enter a single letter.'
  end
end

puts "Let's play a game of hangman!!!\n\n"

game_over = false
word_to_guess = get_random_word(dictionary)
correct_guesses = Array.new(word_to_guess.length) { '_' }
wrong_guesses = []
guesses = []

puts "The word is #{word_to_guess.length} letters long"
puts correct_guesses.join
until game_over
  guess = player_guess
  if guesses.include?(guess)
    puts '***you already guessed that***'
    puts "wrong guesses: #{wrong_guesses}"
    puts correct_guesses.join
    next
  end

  guesses.push(guess).sort!

  if word_to_guess.include?(guess)
    word_to_guess.each_with_index do |letter, index|
      correct_guesses[index] = guess if letter == guess
    end
  else
    wrong_guesses.push(guess).sort!
  end

  # puts "your guesses so far: #{guesses}"
  if correct_guesses == word_to_guess
    puts "\ncongrats!"
    puts "You guessed #{word_to_guess.join} correctly!!"
    game_over = true
  end

  if wrong_guesses.length == 8
    puts "I'm sorry the word was #{word_to_guess.join}"
    game_over = true
  end
  unless game_over == true
    puts "\nwrong guesses: #{wrong_guesses}"
    puts correct_guesses.join
  end
end
