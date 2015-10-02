import static org.junit.Assert.*;
import org.junit.Test;

public class NybblesTester {
	@Test
    public void NybblesTest() {
        Nybbles testA = new Nybbles(8);
        assertEquals(0, testA.get(0));
        assertEquals(0, testA.get(1));
        assertEquals(0, testA.get(3));
        assertEquals(0, testA.get(7));

        testA.set(1, 3);
        testA.set(0, 5);
        testA.set(4, -5);
        assertEquals(5, testA.get(0));
        assertEquals(3, testA.get(1));
        assertEquals(-5, testA.get(4));
        testA.set(1, -2);
        assertEquals(-2, testA.get(1));
        assertEquals(0, testA.get(7));
    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(NybblesTester.class));
    }
}