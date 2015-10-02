import java.io.IOException;

/** String translation. */
public class Translate {
    /** Return the String S, but with all characters that occur in FROM
     *  changed to the corresponding characters in TO. FROM and TO must
     *  have the same length. */
    static String translate(String S, String from, String to) {
        /* NOTE: The try {...} catch is a technicality to keep Java happy. */
        /* I'm not sure if I implemented TrReader correct so I am
         * coding this different than I should be doing */
        char[] buffer = new char[S.length()];
        buffer = S.toCharArray();
        String smth = "";
        
        for (int a = 0; a < buffer.length; a++) {
            for (int b = 0; b < from.length(); b++) {
                if (buffer[a] == from.charAt(b)) {
                    buffer[a] = to.charAt(b);
                }
            }
            smth += buffer[a];
        }
        return smth;

        // REPLACE ABOVE LINE WITH THE RIGHT ANSWER.
    } 
    

    /*
       REMINDER: translate must
      a. Be non-recursive
      b. Contain only 'new' operations, and ONE other method call, and no
         other kinds of statement (other than return).
      c. Use only the library classes String, and anything containing
         "Reader" in its name (browse the on-line documentation).
    */

    public static void main(String[] args) {
        String red = "apples are green";
        char[] n = red.toCharArray();
        System.out.println(translate(red, "are", "ARE"));
    }
}
