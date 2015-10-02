import org.junit.Test;
import static org.junit.Assert.*;

/** FIXME
 *
 *  @author FIXME
 */

public class ListsTest {
    /** FIXME
     */

    /** It might initially seem daunting to try to set up
     *  Intlist2 expected.
   	 *
     * There is an easy way to get the IntList2 that you want in just
     * few lines of code! Make note of the IntList2.list method that
     * takes as input a 2D array. */

    /** Tests to to see if the method naturalRuns() work as
     *  intended. */

    @Test
    public void naturalRunsTest() {
        
        /** This is test #1. */
        IntList testOne = IntList.list(1, 3, 7, 5, 4, 6, 9, 10, 10, 11);
        IntList2 naturalTestOne = Lists.naturalRuns(testOne);
        int[][] checkOne = new int[][]
        {   {1, 3, 7},
            {5},
            {4, 6, 9, 10},
            {10, 11}
        };
        IntList2 checkerOne = IntList2.list(checkOne);
        assertEquals(checkerOne, naturalTestOne);

        /** This is test #2. */
        IntList testTwo = IntList.list(4, 7, 23, 2, 5, 9, 12, 24, 1, 4, 5, 6);
        IntList2 naturalTestTwo = Lists.naturalRuns(testTwo);
        int[][] checkTwo = new int[][]
        {   {4, 7, 23},
            {2, 5, 9, 12, 24},
            {1, 4, 5, 6},
        };
        IntList2 checkerTwo = IntList2.list(checkTwo);
        assertEquals(checkerTwo, naturalTestTwo);


    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(ListsTest.class));
    }
}
