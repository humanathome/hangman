# frozen_string_literal: true

require_relative 'saveable'
require_relative 'loadable'

# main game class
class Hangman
  attr_reader :secret_word, :transformed_word, :mistakes_left

  include Saveable
  include Loadable

  def initialize
    @wrong_guesses = []
  end

  def display_rules
    puts <<~RULES
      Welcome to Hangman!

      HOW TO PLAY:
      Computer will randomly chosen a secret word that is between 5 and 12 letters long.
      You are allowed certain number of mistakes before you lose (length of the secret word + 2).
      You can guess a letter, an entire word, or enter a game command.
      To save the game at any time, type '!save' without the quotes and press enter.
      Good luck!

    RULES
  end

  def play
    display_rules
    choose_game_mode
    start_game_rounds
    determine_game_ending
  end

  private

  def choose_game_mode
    puts 'Would you like to load a saved game? (y/n)'
    gets.chomp.downcase.squeeze == 'y' ? load_game : new_game
  end

  def new_game
    @secret_word = generate_word
    @transformed_word = transform_word
    @mistakes_left = @secret_word.length + 2
    @wrong_guesses = []
    puts "\nNew game started!"
    puts "Secret word is #{@secret_word.length} letters long. You have #{@mistakes_left} mistakes left."
  end

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
      puts "\nSecret word: *** #{@transformed_word} ***"
      puts "Wrong guesses: #{@wrong_guesses.join(', ')}" unless @wrong_guesses.empty?
      puts "Mistakes left: #{@mistakes_left}"
      guess = enter_letter
      break if save_game?(guess)

      check_letter_guess(guess)
      break if word_guessed?
    end
  end

  def enter_letter
    puts "\n__________________________________________"
    puts 'Enter a letter, word, or a command:'
    guess = gets.chomp.downcase

    if @wrong_guesses.include?(guess) || @transformed_word.include?(guess)
      puts "You already guessed '#{guess}'. Try again."
      enter_letter
    else
      guess
    end
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

  def save_game?(player_input)
    return unless player_input == '!save'

    save_game
    true
  end

  def determine_game_ending
    if @mistakes_left.zero?
      puts "YOU LOST... The secret word was '#{@secret_word.upcase}'."
    elsif @transformed_word == @secret_word
      puts "YOU WON! The secret word was '#{@secret_word.upcase}'."
    end
    delete_saved_game if loaded_game_solved_or_lost?
  end
end

Hangman.new.play
