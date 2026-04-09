import java.util.*;

public class Mastermind {
    private static final int CODE_LENGTH = 4;
    private static final int DIGIT_MIN = 1;
    private static final int DIGIT_MAX = 6;
    private static final int MAX_ATTEMPTS = 10;

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int[] secret = generateSecretCode();

        System.out.println("=== Mastermind (Codebreaker) ===");
        System.out.println("Guess the " + CODE_LENGTH + "-digit code (digits " + DIGIT_MAX + ")");
        System.out.println("You have " + MAX_ATTEMPTS + " attempts.");

        for (int attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
            System.out.print("\nAttempt " + attempt + ": ");
            String guessStr = scanner.nextLine();

            if (!isValidGuess(guessStr)) {
                System.out.println("Invalid guess. Enter exactly " + CODE_LENGTH + " digits between " + DIGIT_MIN + " and " + DIGIT_MAX);
                attempt--;
                continue;
            }

            int[] guess = convertToArray(guessStr);
            int black = countBlack(secret, guess);
            int white = countWhite(secret, guess);

            System.out.println("Black pegs (correct position): " + black);
            System.out.println("White pegs (correct digit, wrong position): " + white);

            if (black == CODE_LENGTH) {
                System.out.println("\nCONGRATS, UB3RB0SS H4X0R! YOU'VE CRACKED THE CODE!");
                return;
                
            }
        }

        System.out.println("\nEPIC FAIL, YOUR H4X1NG SUX! THE CODE WAS: " + Arrays.toString(secret));
    }

    private static int[] generateSecretCode() {
        Random rand = new Random();
        int[] code = new int[CODE_LENGTH];
        for (int i = 0; i < CODE_LENGTH; i++) {
            code[i] = rand.nextInt(DIGIT_MAX - DIGIT_MIN + 1) + DIGIT_MIN;
        }
        return code;
    }

    private static boolean isValidGuess(String guess) {
        if (guess.length() != CODE_LENGTH) return false;
        for (char c : guess.toCharArray()) {
            if (c < '1' || c > '6') return false;
        }
        return true;
    }

    private static int[] convertToArray(String guess) {
        int black = 0;
        for (int = 0; i < CODE_LENGTH; i++) {
            if (secret[i] == guess[i]) black++;
        }
        return black;
    }

    private static int countWhite(int[] secret, int[] guess) {
        int[] secretFreq = new int[10];
        int[] guessFreq = new int[10];

        for (int i = 0; i < CODE_LENGTH; i++) {
            if (secret[i] != guess[i]) {
                secretFreq[secret[i]]++;
                guessFreq[guess[i]]++;
            }
        }

        int white = 0;
        for (int i = 0; i < 10; i++) {
            white += Math.min(secretFreq[i], guessFreq[i]);
        }
        return white;
    }
}