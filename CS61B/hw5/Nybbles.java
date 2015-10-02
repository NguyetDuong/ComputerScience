/** Represents an array of integers each in the range -8..7.
 *  Such integers may be represented in 4 bits (called nybbles).
 *  @author
 */
public class Nybbles {
    /** Return an array of size N. */
    public Nybbles(int N) {
        // DON'T CHANGE THIS.
        _data = new int[(N + 7) / 8];
        _n = N;
    }

    /** Return the size of THIS. */
    public int size() {
        return _n;
    }

    /** Return the Kth integer in THIS array, numbering from 0.
     *  Assumes 0 <= K < N. */
    public int get(int k) {
        if (k < 0 || k >= _n) {
            throw new IndexOutOfBoundsException();
        } else {
            //REPLACE STUFF IN ELSE STATEMENT
            int locationInArray = k / 8;
            int locationWithinArraySlot = k % 8;
            //0000 ... 0000 0000 1010 (this would be slot 0!!)
            int shifterBy = 4;
            int allNumsInArray = _data[locationInArray];
            int shiftRight = allNumsInArray >> (locationWithinArraySlot * shifterBy);
            int fixShiftRight = shiftRight << (locationWithinArraySlot * shifterBy);
            int shiftLeft = fixShiftRight << ((7 - locationWithinArraySlot) * shifterBy);
            int returnNumber = shiftLeft >> (7 * shifterBy);
            return returnNumber;
        }
    }

    /** Set the Kth integer in THIS array to VAL.  Assumes
     *  0 <= K < N and -8 <= VAL < 8. */
    public void set(int k, int val) {
        if (k < 0 || k >= _n) {
            throw new IndexOutOfBoundsException();
        } else if (val < -8 || val >= 8) {
            throw new IllegalArgumentException();
        } else {
            //REPLACE THE THING IN DATA STATEMENT
            int locationInArray = k / 8;
            int locationWithinArraySlot = k % 8;
            int shifterBy = 4;
            int allNumsInArray = _data[locationInArray];
            int newValue = val << (locationWithinArraySlot * shifterBy);
            //System.out.println("This is the newValue: " + newValue);
            int left = allNumsInArray >>> ((locationWithinArraySlot + 1) * shifterBy);
            int leftFixed = left << ((locationWithinArraySlot + 1) * shifterBy);
            int right = allNumsInArray << ((8 - locationWithinArraySlot) * shifterBy);
            int rightFixed = right >>> ((8 - locationWithinArraySlot) * shifterBy);
            System.out.println(rightFixed | leftFixed | newValue);

            _data[locationInArray] = rightFixed | leftFixed | newValue;
        }
    }

    // DON'T CHANGE OR ADD TO THESE.
    /** Size of current array (in nybbles). */
    private int _n;
    /** The array data, packed 8 nybbles to an int. */
    private int[] _data;

    public static void main(String[] args) {
        Nybbles testA = new Nybbles(8);
        testA.set(1, 3);
        testA.set(0, 5);
        System.out.println(testA.get(7));
        //testA.set(4, -5);
    }
}
