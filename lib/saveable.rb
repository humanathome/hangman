# frozen_string_literal: true

require 'yaml'

# save the game by saving the state of instance variables to a file
module Saveable
  private

  def save_game
    Dir.mkdir('./saved_games') unless Dir.exist?('./saved_games')
    filename = @loaded_game_name || generate_random_filename
    IO.write("./saved_games/#{filename}", instance_variables_to_yaml)
    puts "Game saved as '#{filename}'. See you later!"
  end

  def instance_variables_to_yaml
    YAML.dump(
      'secret_word' => @secret_word,
      'transformed_word' => @transformed_word,
      'mistakes_left' => @mistakes_left,
      'wrong_guesses' => @wrong_guesses
    )
  end

  def delete_saved_game
    return unless @loaded_game_name

    File.delete("./saved_games/#{@loaded_game_name}")
    puts "Game '#{@loaded_game_name}' removed from saved games directory."
  end

  def generate_random_filename
    adjectives = %w[adorable beautiful clean drab elegant fancy plain]
    colors = %w[red orange yellow green blue indigo violet]
    nouns = %w[apple boat car tree guitar piano planet]
    "#{adjectives.sample}-#{colors.sample}-#{nouns.sample}-#{rand(100..999)}.yaml"
  end
end
