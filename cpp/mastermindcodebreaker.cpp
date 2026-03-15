#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>

using namespace std;

// function declares
vector<int> GenerateSecretCode(int lenght, int maxDigit);
vector<int> GetPlayerGuess(int lenght);
void CheckGuess(const vector<int>& secret, const vector<int>& guess, int& correctPos, int& correctDigit);

int main()
{
    srand(time(0));

    const int CODE_LENGTH = 4;
    const int MAX_DIGIT = 6;
    const int MAX_ATTEMPTS = 10;

    vector<int> secretCode = GenerateSecretCode(CODE_LENGTH, MAX_DIGIT);

    cout << "=== CODEBREAKER ===\n";
    cout << "Guess the " << CODE_LENGTH << "-digit code.\n";
    cout << "Digits range from 1 to " << MAX_DIGIT << ".\n\n";

    for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)
    {
        cout << "Attempt" << attempt << "/" << MAX_ATTEMPTS << endl;

        vector<int> guess = GetPlayerGuess(CODE_LENGTH);
    
        int correctPosition = 0;
        int correctDigit = 0;
    
        CheckGuess(secretCode, guess, correctPosition, correctDigit);

        if (correctPosition == CODE_LENGTH)
        {
            cout << "You cracked the code!\n";
            return 0;
        }

        cout << "Correct digit & position: " << correctPosition << endl;
        cout << "Correct digit but wrong position: " << correctDigit << endl;
        cout << endl;
    }

    cout << "You failed epicly! The code was: ";

    for (int digit : secretCode)
        cout << digit << " ";

    cout << endl;

    return 0;
}

// generate the secret code
vector<int> GenerateSecretCode(int length, int maxDigit)
{
    vector<int> code;

    for (int i = 0; i < length; i++)
    {
        int digit = rand() % maxDigit + 1;
        code.push_back(digit);
    }

    return code;
}

// get player guess
vector<int> GetPlayerGuess(int length)
{
    vector<int> guess(length);

    cout << "Enter your guess: ";

    for (int i = 0; i < length; i++)
    {
        cin >> guess[i];
    }

    return guess;
}

// Compare guess to secret code
void CheckGuess(const vector<int>& secret, const vector<int>& guess, int& correctPos, int& correctDigit)
{
    vector<bool> secretUsed(secret.size(), false);
    vector<bool> guessUsed(guess.size(), false);

    // check correct position first
    for (int i = 0; i < secret.size(); i++)
    {
        if (guess[i] == secret[i])
        {
            correctPos++;
            secretUsed[i] = true;
            guessUsed[i] = true;
        }
    }

    // check correct digit but wrong position
    for (int i = 0; i < guess.size(); i++)
    {
        if (guessUsed[i])
            continue;

        for (int j = 0; j < secret.size(); j++)
        {
            if (!secretUsed[j] && guess[i] == secret[j])
            {
                correctDigit++;
                secretUsed[j] = true;
                break;
            }
        }
    }
}