# frozen_string_literal: true

require_relative 'saveable'
require_relative 'loadable'

# main game class
class Hangman
  attr_reader :secret_word, :transformed_word, :mistakes_left, :player_guess

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
    @secret_word = generate_random_word
    @transformed_word = transform_secret_word
    @mistakes_left = @secret_word.length + 2
    @wrong_guesses = []
    puts "\nNew game started!"
    puts "Secret word is #{@secret_word.length} letters long. You have #{@mistakes_left} mistakes left."
  end

  def generate_random_word
    dictionary = File.open('./google-10000-english-no-swears.txt')
    words_array = []
    dictionary.each_line { |word| words_array.push(word.chomp) if word.length.between?(5, 12) }
    dictionary.close
    words_array.sample
  end

  def transform_secret_word
    @secret_word.split('').map { |_letter| '_' }.join
  end

  def start_game_rounds
    until @mistakes_left.zero?
      puts "\nSecret word: *** #{@transformed_word} ***"
      puts "Wrong guesses: #{@wrong_guesses.join(', ')}" unless @wrong_guesses.empty?
      puts "Mistakes left: #{@mistakes_left}"
      @player_guess = enter_letter
      break if @player_guess == '!save'

      check_player_guess
      break if @transformed_word == @secret_word
    end
  end

  def enter_letter
    puts "\n__________________________________________"
    puts 'Enter a letter, word, or a command:'
    player_input = gets.chomp.downcase

    if invalid_guess?(player_input)
      puts 'Your guess is not valid or you\'ve already guessed it. Try again.'
      enter_letter
    else
      player_input
    end
  end

  def invalid_guess?(guess)
    guess.match?(/\s+/) || @wrong_guesses.include?(guess) || @transformed_word.include?(guess)
  end

  def check_player_guess
    if @player_guess == @secret_word
      @transformed_word = @secret_word
    elsif @player_guess.length == 1 && @secret_word.include?(@player_guess)
      update_transformed_word
      puts "\nCorrect!\n"
    else
      puts "\nIncorrect!\n"
      @mistakes_left -= 1
      @wrong_guesses.push(@player_guess)
    end
  end

  def update_transformed_word
    @secret_word.split('').each_with_index do |letter, index|
      @transformed_word[index] = letter if letter == @player_guess
    end
  end

  def determine_game_ending
    if @mistakes_left.zero?
      puts "YOU LOST... The secret word was '#{@secret_word.upcase}'."
    elsif @transformed_word == @secret_word
      puts "YOU WON! The secret word was '#{@secret_word.upcase}'."
    end
    save_game if @player_guess == '!save'
    delete_saved_game if loaded_game_solved_or_lost?
  end
end

Hangman.new.play
