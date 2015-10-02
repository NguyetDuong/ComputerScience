/** An alternative addition procedure based on bit operations.
 *  without using the operators +, -, /, *, or \%, ++, --, +=, -=, *=, \=,
 *  %=, or any method calls. Instead, use the bitwise operators &, |, ^, ~,
 *  <<, >>, >>>, and &=, etc.
 *  @author
 */
public class Adder {
    /** Returns X+Y. */
    public static int add(int x, int y) {
        int a = x;
        int b = -y;
        for (int i = 0; i < 32; i += 1) {
        	a = a ^ b;
        	b = (a & b) << 1;
      	}

      	return a;
    }

    


    public static void main(String[] args) {
    	int a = 16;
    	int b = 14;
    	System.out.println(add(4, 7));
    }

}
