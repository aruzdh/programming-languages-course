## Solution template for Guess The Word practice problem (section 7)

require_relative './providedcode'

class ExtendedGuessTheWordGame < GuessTheWordGame
  def initialize(secret_word_class)
    super secret_word_class
    @guesses = []
  end

  def ask_for_guessed_letter
    puts 'Secret word:'
    puts @secret_word.pattern
    puts @mistakes_allowed.to_s + ' incorrect guess(es) left.'
    puts 'Enter the letter you want uncovered:'
    letter = gets.chomp

    if @guesses.include? letter.downcase
      puts "You've used this lette before. Try again"
      return
    end

    @guesses.push letter.downcase

    if @secret_word.valid_guess? letter
      if !@secret_word.guess_letter! letter
        @mistakes_allowed -= 1
        @game_over = @mistakes_allowed == 0
      else
        @game_over = @secret_word.is_solved?
      end
    else
      puts "I'm sorry, but that's not a valid letter."
    end
  end
end

class ExtendedSecretWord < SecretWord
  def initialize(word)
    super word
    @pattern = word.gsub(/[a-zA-Z]/, '-')
  end

  def valid_guess?(guess)
    guess.length == 1 && guess.match(/[a-zA-Z]/)
  end

  def guess_letter!(letter)
    aux_letter = letter.downcase
    aux_word = word.downcase
    found = aux_word.index aux_letter
    if found
      start = 0
      while (ix = aux_word.index(aux_letter, start))
        pattern[ix] = word[ix]
        start = ix + 1
      end
    end
    found
  end
end

## Change to `false` to run the original game
if true
  ExtendedGuessTheWordGame.new(ExtendedSecretWord).play
else
  GuessTheWordGame.new(SecretWord).play
end
