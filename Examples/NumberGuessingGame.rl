FN numgame()
  print("!Number Guessing Game!")

  DEC randnum = random(1, 100)
  DEC guesses = 0
  DEC guess = ""
  DEC wrong = 1 == 1

  WHILE wrong DO
    guesses = guesses + 1
    guess = get("Guess a number between 1 and 99:")
    
    IF guess == tostr(randnum) DO
      wrong = 1 == 0
    STOP

    IF guess < randnum DO
      print("Too low!")
    STOP

    IF guess > randnum DO
      print("Too high!")
    STOP
  STOP

  print(concat("You got it right in ", concat(guesses, " guesses!")))
STOP

numgame()
