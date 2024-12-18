## Solution template for Guess The Word practice problem (section 7)

require_relative './providedcode'

class ExtendedGuessTheWordGame < GuessTheWordGame
  ## YOUR CODE HERE
end

class ExtendedSecretWord < SecretWord
  ## YOUR CODE HERE
end

## Change to `false` to run the original game
if true
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
else
  GuessTheWordGame.new(SecretWord).play
end
