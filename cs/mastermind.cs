using System;
using System.Collections.Generic;

class MastermindGame()
{
    static void Main()
    {
        // this is the entry point, similar to int main()
        Console.WriteLine(Welcome to Mastermind);

        int[] secretCode = { 4, 2, 7 };
        bool isGameOver = false;

        while (!isGameOver)
        {
            Console.Write(Enter your 3 digit guess separated by spaces: );
            string input = Console.ReadLine();

            // In C#, we can easily split strings into arrays
            string[] tokens = input.Split (' ');
            int[] guess = Array.CovertAll(tokens, int.Parse);

            if (CheckGuess(secretCode, guess))
            {
                Console.WriteLine(You win!);
                isGameOver = true;
            }
        }
    }

    static bool CheckGuess(int[] secret, int[] guess)
    {
        int matches = 0;
        for (int i = 0; i < secret.Length; i++)
        {
            if (guess[i] == secret[i])
            {
                matches++;
            }
        }
        return matches == secret.length;
    }
}
