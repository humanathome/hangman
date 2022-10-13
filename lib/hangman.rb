# frozen_string_literal: true

require_relative 'saveable'

# main game class
class Hangman
  include Saveable

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
      You can guess a letter, an entire word, or enter a game command.
      To save the game at any time, type '!save' without the quotes and press enter.
      Good luck!
    RULES
  end

  def play
    display_rules
    puts "\nSecret word: *** #{@transformed_word} ***"
    start_game_rounds
    determine_game_ending
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

  def start_game_rounds
    until @mistakes_left.zero?
      guess = enter_letter
      break if save_game?(guess)

      check_letter_guess(guess)
      break if word_guessed?

      puts "Secret word: *** #{@transformed_word} ***\n\n"
      puts "Wrong guesses: #{@wrong_guesses.join(', ')}" unless @wrong_guesses.empty?
      puts "Mistakes left: #{@mistakes_left}"
    end
  end

  def enter_letter
    puts "\n__________________________________________"
    puts 'Enter a letter, word, or a command:'
    gets.chomp.downcase
  end

  def check_letter_guess(guess)
    if guess == @secret_word
      @transformed_word = @secret_word
    elsif guess.length == 1 && @secret_word.include?(guess)
      update_word(guess)
      puts "\nCorrect!\n"
    else
      puts "\nIncorrect!\n"
      @mistakes_left -= 1
      @wrong_guesses.push(guess)
    end
  end

  def update_word(guess)
    @secret_word.split('').each_with_index do |letter, index|
      @transformed_word[index] = letter if letter == guess
    end
  end

  def word_guessed?
    @transformed_word == @secret_word
  end

  def save_game?(guess)
    return unless guess == '!save'

    save_game
    true
  end

  def determine_game_ending
    if @mistakes_left.zero?
      puts "YOU LOST... The secret word was '#{@secret_word.upcase}'."
    elsif @transformed_word == @secret_word
      puts "YOU WON! The secret word was '#{@secret_word.upcase}'."
    end
  end
end

Hangman.new.play
