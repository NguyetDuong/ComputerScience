import org.junit.Test;
import static org.junit.Assert.*;

/** FIXME
 *  @author FIXME
 */

public class MatrixUtilsTest {
    /** FIXME
     */

    @Test
    public void accumulateVerticalTest() {
    	double[][] a = new double[][] {
            {1000000, 1000000, 1000000, 1000000},
            {1000000, 75990, 30003, 1000000},
            {1000000, 30002, 103046, 1000000},
            {1000000, 29515, 38273, 1000000},
            {1000000, 73403, 35399, 1000000},
            {1000000, 1000000, 1000000, 1000000}
        };

        double[][] checker = accumulateVerticalTest(a);

        double[][] correct = new double[][] {
        	{1000000, 1000000, 1000000, 1000000},
            {2000000, 1075990, 1030003, 2000000},
            {2075990, 1060005, 1133049, 2030000},
            {2060005, 1089520, 1098278, 2133049},
            {2089520, 1162923, 1124919, 2098278},
            {2162923, 2124919, 2124919, 2124919}
        }

        assertArrayEquals(correct, chercker);
    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(MatrixUtilsTest.class));
    }
}
