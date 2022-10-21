# frozen_string_literal: true

# show, find and load saved game files
module Loadable
  attr_reader :all_saved_games, :loaded_game_name

  def show_saved_games
    @all_saved_games = saved_games_list_to_hash
    puts "\nYou have #{@all_saved_games.length} saved games:"
    @all_saved_games.each { |key, value| puts "#{key}. #{value}" }
  end

  def find_saved_game_file
    puts "\nEnter the number of the saved game you would like to load:\n"
    game_number = gets.chomp.to_i
    @loaded_game_name = @all_saved_games[game_number]
    return unless @loaded_game_name.nil?

    puts 'Invalid game number. Please try again.'
    find_saved_game_file
  end

  def load_game
    show_saved_games
    find_saved_game_file
    load_file_values(@loaded_game_name)
    puts "Game '#{@loaded_game_name}' loaded!"
  end

  def saved_games_list_to_hash
    saved_games_list = Dir.children('./saved_games')
    game_numbers = (1..saved_games_list.length).to_a
    game_numbers.zip(saved_games_list).to_h
  end

  def load_file_values(game_file)
    chosen_game_file = YAML.load_file("./saved_games/#{game_file}")
    @secret_word = chosen_game_file['secret_word']
    @transformed_word = chosen_game_file['transformed_word']
    @mistakes_left = chosen_game_file['mistakes_left']
    @wrong_guesses = chosen_game_file['wrong_guesses']
  end

  def loaded_game_solved_or_lost?
    return if @loaded_game_name.nil?

    @transformed_word == @secret_word || @mistakes_left.zero?
  end
end
