import java.io.FileReader;
import java.io.Reader;
import java.io.IOException;
import java.util.Arrays;

/** Tests the TrReader class
 *  @author Josh Hug
 */

public class TrReaderTest {
    /** Tests the TrReader class
     */

    public static void main(String[] args) throws IOException {
        Reader r = new FileReader("TrReaderTest.java");
        System.out.print("This tests reads in some of the source code for ");
        System.out.print("this test. Then feeds it into TrReader. If it ");
        System.out.print("works, you should see the source for this test, ");
        System.out.println("but scrambled.");

        TrReader trR = new TrReader(r, "import jav.", "josh hug___");
        char[] cbuf = new char[250];

        /* Reads 150 characters from the buffer */
        trR.read(cbuf);
        System.out.println(new String(cbuf));
    }
}