## The Odin Project: Hangman
This project is a part of The Odin Project's Ruby curriculum.
Project link: [Hangman](https://www.theodinproject.com/lessons/ruby-hangman)

### Description
Simple Ruby CLI word guessing game where one player plays against the computer. Computer chooses a random secret word 
between 5 and 12 letters long. Player tries to guess the secret word within limited number of mistakes, for example: 
if the secret word is 7 letters long, the player is able to make 9 mistakes (length of the secret word + 2 extra 
guesses). If player manages to guess the secret word before making 9 mistakes he wins, otherwise he loses.

### Features
- Computer will choose a random secret word from a dictionary of 10,000 words. Word will be between 5 and 12 letters 
long
- Player can choose whether they wanna play a new game or load a previously saved game
- Player can guess a single letter or an entire word at once
- Player can type a game command `!save` to save the game at player's turn
- Player can choose to play again after the game is over
- If a loaded game is saved again, it will overwrite the previously saved game file
- If a loaded game is solved or lost, it will be deleted from the saved games directory
 
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
ruby hangman.rb
```

