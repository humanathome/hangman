# frozen_string_literal: true

# main game class
class Hangman
  def initialize
    @secret_word = generate_word
    @transformed_word = transform_word
    @mistakes_left = @secret_word.length + 2
    @wrong_guesses = []
  end

  def display_rules
    puts <<~RULES
      Welcome to Hangman!

      HOW TO PLAY:
      Computer has randomly chosen a secret word that is #{@secret_word.length} letters long.
      You are allowed #{@mistakes_left} mistakes before you lose.
      To guess a letter, type the letter and press enter.

      Good luck!
    RULES
  end

  def play
    display_rules
    until @mistakes_left.zero?
      check_letter_guess(enter_letter)
      break if @transformed_word == @secret_word

      puts "Wrong guessed letters: #{@wrong_guesses.join(', ')}" unless @wrong_guesses.empty?
      puts "Mistakes left: #{@mistakes_left}"
    end
    puts 'Game over!'
    determine_game_result
    puts "The word was #{@secret_word.upcase}."
  end

  private

  def generate_word
    dictionary = File.open('./google-10000-english-no-swears.txt')
    words_array = []
    dictionary.each_line do |word|
      word = word.chomp
      words_array.push(word) if word.length.between?(5, 12)
    end
    dictionary.close
    words_array.sample
  end

  def transform_word
    @secret_word.split('').map { |_letter| '_' }.join
  end

  def enter_letter
    puts "\nPlease enter a single letter:"
    puts @transformed_word
    letter = gets.chomp
    enter_letter unless letter.downcase.match?(/[a-z]/) && letter.length == 1
    letter.downcase
  end

  def check_letter_guess(guess)
    if @secret_word.include?(guess)
      puts "\nCorrect!"
      update_word(guess)
    else
      puts "\nIncorrect!"
      @mistakes_left -= 1
      @wrong_guesses.push(guess)

    end
  end

  def update_word(guess)
    @secret_word.split('').each_with_index do |letter, index|
      @transformed_word[index] = letter if letter == guess
    end
  end

  def determine_game_result
    if @mistakes_left.zero?
      puts 'YOU LOST...'
    else
      puts 'YOU WON!'
    end
  end
end

Hangman.new.play
