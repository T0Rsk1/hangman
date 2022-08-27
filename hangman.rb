# frozen_string_literal: true

# Hangman
class Hangman
  attr_reader :clues, :word

  def initialize
    @min_length = 5
    @max_length = 12
    @word = select_random_word
    @clues = convert_to_dash(@word)
    @tries = 10
    @used = []
  end

  def convert_to_dash(word)
    ''.rjust(word.length, '_')
  end

  def letter_in_word?(letter)
    @word.include?(letter)
  end

  def replace_dash(guess)
    @word.chars.each_with_index { |letter, i| @clues[i] = guess if letter == guess }
  end

  def remove_words(dictionary, min, max)
    dictionary.filter { |word| word.length >= min && word.length <= max }
  end

  def select_random_word
    remove_words(
      File.readlines('google-10000-english-no-swears.txt', chomp: true),
      @min_length,
      @max_length
    ).sample
  end

  def input_guess
    guess = ''

    until letter?(guess) && !@used.include?(guess)
      print 'Guess a letter from the word: '
      guess = gets.chomp
      puts "\n"
      puts "Try again! Needs to be one letter!\n\n" unless letter?(guess)
      puts "Letter already used!\n\n" if @used.include?(guess)
    end
    guess
  end

  def letter?(guess)
    guess.match?(/^[a-z]$/)
  end

  def save_game; end

  def play
    puts "GAME STARTED\n\n"

    until @tries.zero?
      puts "Used letters: #{@used.join(', ')}\n\n"
      puts "  #{@clues}\n\n"

      guess = input_guess
      @used << guess

      if letter_in_word?(guess)
        replace_dash(guess)
        puts "Perfect! '#{guess}' is in the word!\n\n"
      else
        puts "The word does not contain any #{guess}'s\n\n"
      end

      @tries -= 1
      puts "You have #{@tries} more tries left\n\n"
    end
    puts "The word was '#{@word}'\n\n"
    puts 'GAMEOVER'
  end
end

h = Hangman.new
h.play
