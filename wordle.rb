require 'cli/ui'
require './word_bank.rb'

LETTERS = %w[Q W E R T Y U I O P A S D F G H J K L Z X C V B N M]
UNKNOWN = ' '
CORRECT = 'o'
ELSEWHERE = '*'
WRONG = 'x'

def initialize_state
  {
    secret_word: WORD_BANK.sample,
    attempts: [],
  }
end

def display_state(state)
  puts
  state[:attempts].each do |attempt|
    puts attempt
    puts attempt_status(attempt, state[:secret_word])
  end
  puts
  puts LETTERS.join
  puts LETTERS.map{|letter| letter_status(letter, state[:attempts], state[:secret_word])}.join
end

def letter_status(letter, attempts, secret_word)
  all_guesses = attempts.map(&:chars).flatten
  return UNKNOWN unless all_guesses.include?(letter)
  return WRONG unless secret_word.chars.include?(letter)
  attempts.map(&:chars).transpose.zip(secret_word.chars).each do |position_attempts, secret_letter|
    return CORRECT if letter == secret_letter && position_attempts.include?(secret_letter)
  end
  return ELSEWHERE
end

def attempt_status(attempt, secret_word)
  attempt_chars = attempt.chars
  secret_chars = secret_word.chars
  foo = attempt_chars.zip(secret_chars)

  foo.map do |attempt_char, secret_char|
    if attempt_char == secret_char
      CORRECT
    elsif secret_chars.include? attempt_char
      ELSEWHERE
    else
      WRONG
    end
  end.join
end

def prompt_attempt(state)
  puts
  attempt = ''
  while not WORD_BANK.include?(attempt)
    attempt = CLI::UI.ask('Guess a word!')
  end
  state[:attempts] << attempt.upcase
  state
end

state = initialize_state
display_state(state)
while not state[:attempts].include? state[:secret_word]
  prompt_attempt(state)
  display_state(state)
end