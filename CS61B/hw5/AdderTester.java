import org.junit.Test;
import static org.junit.Assert.*;


public class AdderTester {
    @Test
    public void addTest() {
        Adder testing = new Adder();
        assertEquals(21, testing.add(4, 17));
        assertEquals(-3, testing.add(4, -7));
        assertEquals(12, testing.add(-2, 14));
        
    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(AdderTester.class));
    }


    
}