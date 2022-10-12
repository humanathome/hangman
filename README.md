## The Odin Project: Hangman
This project is a part of The Odin Project's Ruby curriculum.
Project link: [Hangman](https://www.theodinproject.com/lessons/ruby-hangman)

### Description
Simple command line Hangman game where one player can play against the computer.

### Features
- Computer chooses a random word between 5 and 12 letters long from a text file
- Number of guesses that player has is based on the length of the word + 2 
(e.g. if the word is 5 letters long, the player has 7 guesses)
- Player can guess a letter or the entire word at once
- Player can type a command to save the game at player's turn
- Player can load a saved game at the beginning of the game
- Player can choose to play again after the game is over
 
### Built with
- ruby 3.0.0 (managed by `asdf` in [.tool-versions](.tool-versions))

### Run locally

Prerequisites: ruby >= 3.0.0

- clone the repository
```
git clone git@github.com:humanathome/hangman.git
```

- cd into the cloned repository
```
cd hangman
```

- run
```
ruby lib/hangman.rb
```

