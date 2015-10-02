/** A WeirdList holds a sequence of integers.

    For part 3a, implement enough so that length() and print() work.
    For part 3b, implement map and WeirdListClient.add.
    For optional part 3c, implement WeirdListClient.sum.
*/
public class WeirdList {
    /** The empty sequence of integers. */
    public static final WeirdList EMPTY =
        new WeirdListEnd();  // REPLACE THIS LINE WITH THE RIGHT ANSWER.
    private int begin;
    private WeirdList end;

    /** A new WeirdList whose head is HEAD and tail is TAIL. */
    public WeirdList(int head, WeirdList tail) { 
        //System.out.println(tail);
        begin = head;
        end = tail;
    }

    /** Returns the number of elements in the sequence that
     *  starts with THIS. */
    public int length() {
        return 1 + end.length();  // REPLACE THIS LINE WITH THE RIGHT ANSWER.
    }

    /** Print the contents of THIS WeirdList on the standard output
     *  (on one line, each followed by a blank).  Does not print
     *  an end-of-line. */
    public void print() {
        System.out.print(begin);
        System.out.print(" ");
        end.print();
    }

    /** Part 3b: Apply FUNC.apply to every element of THIS WeirdList in
     *  sequence, and return a WeirdList of the resulting values. */
    public WeirdList map(IntUnaryFunction func) {
        return new WeirdList(func.apply(begin), end.map(func));  // REPLACE THIS LINE WITH THE RIGHT ANSWER.
    }

    public WeirdList add(int n) {
        return new WeirdList(begin + n, end.add(n));
    }

    // For parts 3a, 3b, and 3c:
    //
    // You should not add any methods to WeirdList, but you will need
    // to add private fields (e.g. head).
    //
    // But that's not all!

    // You will need to create at least one additional class for WeirdList
    // to work. This is because you are forbidden from using any of the
    // following in ANY of the code for HW3 (we won't actually check,
    // but, you're depriving yourself of a cool problem if you do):
    //       if, switch, while, for, do, try, or the ?: operator.

    // I do not expect you to necessarily know where to even start.
    // If you'd like an obtuse hint, scroll to the very bottom of this
    // file.

    // You can create this hypothetical class (or classes) in separate
    // files like you usually od, or if you're feeling bold you can
    // actually stick them INSIDE of this class. Yes, nested classes
    // are a thing in Java.

    // As an example:
    // private static class Potato {
    //    int n;
    //    public Potato(int nval) {
    //       n = nval;
    //    }
    // }
    //
    // The above would define a class that lives inside WeirdList.
    // You are NOT required to do this, just an extra thing you can
    // do if you want to avoid making a separate .java file.

    private static class WeirdListEnd extends WeirdList{
        public WeirdListEnd() {
            super(9, null);
        }

        public int length() {
            return 0;
        }


        public void print() {
            System.out.println("");
        }

        public WeirdList map(IntUnaryFunction func) {
            return new WeirdListEnd();
        }

        public WeirdList add(int n) {
            return new WeirdListEnd();
        }
    }

    public static void main(String[] args) {
        WeirdList wl1 = new WeirdList(5, WeirdList.EMPTY);
        WeirdList wl2 = new WeirdList(6, wl1);
        WeirdList wl3 = new WeirdList(10, wl2);
        //assertEquals(wl3.length(), 3);
        //assertEquals(wl1.length(), 1);

        /* Should print 10 6 5 */
        wl3.print();

    }

}


















// Hint: The first non-trivial thing you'll probably do to WeirdList
// is to fix the EMPTY static variable so that it points at something
// useful.
