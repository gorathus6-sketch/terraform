using System;

class MastermindGame
{
    static void Main()
    {
        // Initialize the random object one
        Random rng = new Random();

        int codeLength = 3;
        int[] secretCode = new int[codelength];

        // fill the array with random numbers between 1-9
        for (int i = 0; i <codelength; i++)
        {
            // Next(min, max) is inclusive of min, exclusive of max
            secretCode[i] = rng.Next(1, 10);
        }

        Console.WriteLine(A new secret code has been generated.);

        // the rest of the game logic goes here
    }
}