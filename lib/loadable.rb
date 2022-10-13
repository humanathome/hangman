# frozen_string_literal: true

# show, find and load saved game files
module Loadable
  def show_saved_games
    puts 'Saved games:'
    Dir.children('./saved_games').each_with_index do |filename, index|
      puts "#{index + 1}. #{filename}"
    end
  end

  def find_saved_game_file
    puts 'Enter the number of the saved game you would like to load:'
    game_number = gets.chomp.to_i
    all_saved_games = Dir.children('./saved_games')
    unless game_number.between?(1, all_saved_games.length)
      puts 'Invalid game number.'
      find_saved_game_file
    end
    all_saved_games[game_number - 1]
  end

  def load_game
    show_saved_games
    load_file_values
  end

  def load_file_values
    chosen_game_file = YAML.load_file("./saved_games/#{find_saved_game_file}")
    @secret_word = chosen_game_file['secret_word']
    @transformed_word = chosen_game_file['transformed_word']
    @mistakes_left = chosen_game_file['mistakes_left']
    @wrong_guesses = chosen_game_file['wrong_guesses']
  end
end
