import org.junit.Test;
import static org.junit.Assert.*;

/** FIXME
 *  @author FIXME
 */

public class ArraysTest {
    /** FIXME
     */


    /** This is the test for the method catenate() in the
     *	class Arrays. */
    @Test
    public void catenateTest() {

    	/** This is test #1. */
    	int[] a = new int[] {1, 2, 3, 4};
        int[] b = new int[] {5, 6, 3, 4, 5, 6};
        int[] c = Arrays.catenate(a, b);
        int[] testC = new int[] {1, 2, 3, 4, 5, 6, 3, 4, 5, 6};
        assertArrayEquals(testC, c);

        /** This is test #2. */
        int[] k = new int[] {28, 3, 12, 94, 2, 4};
        int[] j = new int[] {1, 5, 23, 69, 6, 3, 23};
        int[] i = Arrays.catenate(k, j);
        int[] testI = new int[] {28, 3, 12, 94, 2, 4, 1, 5, 23, 69, 6, 3, 23};
        assertArrayEquals(testI, i);
    }

    @Test
    public void removeTest() {
        /** This is test #1 */
        int[] a = new int[] {1, 2, 3, 4, 5, 6, 3, 4, 5, 6};
        int[] testA = Arrays.remove(a, 4, 3);
        int[] b = new int[] {1, 2, 3, 3, 4, 5, 6};
        assertArrayEquals(testA, b);

        /** This is test #2 */
        int[] c = new int[] {28, 3, 12, 94, 2, 4};
        int[] testC = Arrays.remove(c, 1, 3);
        int[] d = new int[] {94, 2, 4};
        assertArrayEquals(testC, d);

    }
    
    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(ArraysTest.class));
    }
}
