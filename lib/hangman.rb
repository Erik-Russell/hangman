# frozen_string_literal: true

# load dictionary
dictionary = []
File.foreach('google-10000-english-noswears.txt') do |line|
  dictionary << line.strip if line.chomp.length.between?(5, 12)
end

# return randowm word as array of letters
def get_random_word(dictionary)
  dictionary[rand(dictionary.count)].split('')
end
