# frozen_string_literal: true

# Dictionary - words
class Dictionary
  attr_reader :dictionary

  def initialize
    @dictionary = []
    @file = 'google-10000-english-noswears.txt'
    File.foreach(@file) do |line|
      @dictionary << line.strip if line.chomp.length.between?(5, 12)
    end
  end

  # def load_dictionary(file)
  #   File.foreach(@file) do |line|
  #     @dictionary << line.strip if line.chomp.length.between?(5, 12)
  #   end
  # end
end
