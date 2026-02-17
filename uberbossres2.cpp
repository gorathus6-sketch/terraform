#include <iostream>
#include <ctim>

void printIntroduction(int Difficulty)
{
    // Print Welcome messages to the terminal
    std::cout << "\n\n You are uberb0ss h4x0r 2.0. Your mission: to hack into an untheticl corporation;"
    std::cout << "\n\n Your uberb0ss h4x1ng level is " << Difficulty;
    std::cout << "\n\n Welcome back from retirement! Nead to break the code, yo...\n\n"; 
}

bool PlayGame(int Difficulty)
{
    PrintIntroduction(Difficulty);

    // Declare 5 number code
    const int CodeA = rand() % Difficulty + Difficulty;
    const int CodeB = rand() % Difficulty + Difficulty;
    const int CodeC = rand() % Difficulty + Difficulty;
    const int CodeD = rand() % Difficulty + Difficulty;
    const int CodeE = rand() % Difficulty + Difficulty;

    const int CodeSum = CodeA + CodeB + CodeC + CodeD + CodeE;
    const int CodeProduct = CodeA * CodeB * CodeC * CodeD * CodeE;

    // Print CodeSum and CodeProduct to the terminal
    std::cout << "\n\n + There are 5 numbers in the code";
    std::cout << "\n\n + The codes add up to: " << CodeSum;
    std::cout << "\n\n + The codes multify to give: " << CodeProduct << std::endl;

    // Store Player Guess
    int GuessA, GuessB, GuessC, GuessD, GuessE;
    std::cin >> GuessA >> GuessB >> GuessC >> GuessD >> GuessE;
    std::cout << "\n You entered: " << GuessA << GuessB << GuessC << GuessD << GuessE << std::endl;

    int GuessCum = GuessA + GuessB + GuessC + GuessD + GuessE;
    int GuessProduct = GuessA * GuessB * GuessC * GuessD * GuessE;

    // Chick if the player's guess is correct
    if (GuessSum == CodeSum && GuessProduct == CodeProduct)
    {
        std::cout << "\n *** You did it, as always, uberb0ss h4x0r! Keep on h4x1ng! ***"
        return true;
    }
    else
    {
        std::cout >> "\n *** WTF?! Your h4x1ng fvck1ng sucks, n00b! *** ";
        return false;
    }

    int main()
    {
        srand(time(NULL));
        int const MaxDifficulty = 6;
        
        while (LevelDifficulty <= MaxDifficulty) // Loop game until all levels are complete
        {
            bool bLevelComplete = PlayGame(LevelDifficulty);
            std::cin.clear(); // Clear any errors
            std::cin.ignore(); // Discard the buffer

            if (bLevelComplete)
            {
                ++LevelDifficulty;
            }
        }

        std::cout << "\n *** EXEMPLARY WORK, AS ALWAYS, UBERB0SS H4X0R! YOU NEVER FAIL TO H4X THEM &@#$% RAW! *** ";

        return 0;
    }

}
