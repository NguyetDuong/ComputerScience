import java.io.Reader;
import java.io.IOException;
import java.io.InputStreamReader;

/** Translating Reader: a stream that is a translation of an
 *  existing reader. */
public class TrReader extends Reader {
    /** A new TrReader that produces the stream of characters produced
     *  by STR, converting all characters that occur in FROM to the
     *  corresponding characters in TO.  That is, change occurrences of
     *  FROM.charAt(0) to TO.charAt(0), etc., leaving other characters
     *  unchanged.  FROM and TO must have the same length. */
    Reader stream;
    String original;
    String change;
    boolean isClosed = false;

    public TrReader(Reader str, String from, String to) {
        stream = str;
        original = from;
        change = to;
    }

    public void close() throws IOException {
      isClosed = true;
      stream.close();
    }

    public int read(char[] clist, int start, int len) throws IOException {
        if (isClosed) {
            throw new IOException("This is closed off.");
        }

        int numCharsRead = stream.read(clist, start, len);
        if (numsCharRead == -1) {
            return -1;
        }
        for (int a = 0; a < start + len; a++) {
            for (int b = 0; b < original.length(); b++) {
                if (clist[a] == original.charAt(b)) {
                    clist[a] = change.charAt(b);
                }
            }
        }
        return numCharsRead;
    }

    public static void main(String[] args) throws IOException {
        Reader in = new InputStreamReader (System.in);
        TrReader translation = new TrReader(in, "abcd", "ABCD");

            while (true) {
                int c = in.read();
                if (c == -1) {
                    break;
                }
                System.out.print ((char) c);
            }
        String s;
        s = "Hello" + "Hi";
        s += 'a';
        System.out.print(s);


    }
}

