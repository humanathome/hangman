# frozen_string_literal: true

# contains methods for displaying textual info
module Displayable
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

  def display_new_game_message
    puts "\nNew game started!"
    puts "Secret word is #{@secret_word.length} letters long. You have #{@mistakes_left} mistakes left."
  end

  def display_player_input_prompt
    puts "\n__________________________________________"
    puts 'Enter your guess (letter or word):'
  end

  def display_round_results
    puts "\nSecret word: *** #{@transformed_word} ***"
    puts "Wrong guesses: #{@wrong_guesses.join(', ')}" unless @wrong_guesses.empty?
    puts "Mistakes left: #{@mistakes_left}"
  end

  def display_win
    puts "Congratulations! YOU WON! The secret word was '#{@secret_word.upcase}'."
  end

  def display_loss
    puts "Sorry, you lost. The secret word was '#{@secret_word.upcase}'."
  end

  def display_saved_games
    @all_saved_games = saved_games_list_to_hash
    puts "\nYou have #{@all_saved_games.length} saved games:"
    @all_saved_games.each { |key, value| puts "#{key}. #{value}" }
  end
end
