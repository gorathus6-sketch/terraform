import random

def print_introduction(difficulty):
    print("\nYou are uberb0ss h4x0r 2.0. Your missions: hack into an unethical corporation.")
    print(f"Your uberb0ss h4x1ng level is {difficulty}.")
    print("Welcome back from retirement! Time to break the code ... \n")

def play_game(difficulty):
    print_introduction(difficulty)

    # Generate 5 random numbers based on difficulty

    code = [random.randint(difficulty, difficulty * 2) for _ in range(5)]
    code_sum = sum(code)

    # product of all numbers

    code_product = 1
    for n in code:
        code_product *= n

    print("+ There are 5 numbers in the code")
    print(f"+ The codes add up to: {code_sum}")
    print(f"+ The codes multiply to give: {code_product}")

    # player guess

    guess_input = input("\nEnter your 5 guesses seperated by spaces: ")
    try:
        guesses = list(map(int, guess_input.split()))
        if len(guesses) != 5:
            print("You must enter exactly 5 numbers.")
            return False
    except ValueError:
        print("Invalid input. Enter numbers only.")
        return False

    guess_sum = sum(guesses)

    guess_product = 1
    for n in guesses:
        guess_product *= n

    # check win condition

    if guess_sum == code_sum and guess_product == code_product:
        print("\n*** You did it, uberb0ss h4x0r! Keep on h4x1ng! ***")
        return True
    else:
        print("\n*** WTF?! Your h4x1ng sucks, n00b! Try again! ***")
        return False

def main():
    max_difficulty = 6
    level = 1

    while level <= max_difficulty:
        if play_game(level):
            level += 1

    print("\n*** EXEMPLARY WORK, UBERB0SS H4X0R! YOU NEVER FAIL! ***")

if __name__ == "__main__":
    main()

