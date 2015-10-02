/* NOTE: The file ArrayUtil.java contains some functions that may be useful
 * in testing your answers. */

/** HW #2, Problem #2. */

/** Array utilities.
 *  @author
 */
class Arrays {
    /* 2a. */
    /** Returns a new array consisting of the elements of A followed by the
     *  the elements of B. */
    static int[] catenate(int[] A, int[] B) {
        int[] items = new int[A.length + B.length];
        for (int a = 0; a < A.length; a++) {
            items[a] = A[a];
        }

        for (int a = A.length, b = 0; b < B.length; b++, a++) {
            items[a] = B[b];
        }
        return items;
    }

    /* 2b. */
    /** Returns the array formed by removing LEN items from A,
     *  beginning with item #START. */
    static int[] remove(int[] A, int start, int len) {
        int[] replace = new int[A.length - len];
        for (int a = 0; a < start - 1; a++) {
            replace[a] = A[a];
        }

        for (int a = start - 1 + len, b = start - 1;
            b < replace.length; b++, a++) {
            replace[b] = A[a];
        }

        return replace;
    }

    /* 4 (optional). */
    /** Returns the array of arrays formed by breaking up A into
     *  maximal ascending lists, without reordering.
     *  For example, if A is {1, 3, 7, 5, 4, 6, 9, 10}, then
     *  returns the three-element array
     *  {{1, 3, 7}, {5}, {4, 6, 9, 10}}. */
    static int[][] naturalRuns(int[] A) {
        /* *Replace this body with the solution. */
        return null;
    }
}
