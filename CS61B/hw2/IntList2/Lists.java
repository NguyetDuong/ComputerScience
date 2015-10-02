/* NOTE: The file Utils.java contains some functions that may be useful
 * in testing your answers. */

/** HW #2, Problem #1. */

/** List problem.
 *  @author Nguyet Duong
 */
class Lists {
    /** Return the list of lists formed by breaking up L into "natural runs":
     *  that is, maximal strictly ascending sublists, in the same order as
     *  the original.  For example, if L is (1, 3, 7, 5, 4, 6, 9, 10, 10, 11),
     *  then result is the four-item list ((1, 3, 7), (5), (4, 6, 9, 10), (10, 11)).
     *  Destructive: creates no new IntList items, and may modify the
     *  original list pointed to by L. */
    static IntList2 naturalRuns(IntList L) {
        int lengthOfList = countLength(L, 1);
        int amountOfSubList = 0;
        int[] allNums1DArray = intListArrayConverter(L, lengthOfList);
        int subListAmounts = 1;

        for (int a = 0; a < lengthOfList - 1; a++) {
            if (allNums1DArray[a] >= allNums1DArray[a + 1]) {
                subListAmounts++;
            }
        }

        int[][] numsIn2DArray = new int[subListAmounts][];

        for (int a = 0, b = 1, c = 0; c < lengthOfList; c++) {
            if (c == lengthOfList - 1) {
                numsIn2DArray[a] = new int[b];
            } else if (allNums1DArray[c] < allNums1DArray[c + 1]) {
                b++;
            } else {
                numsIn2DArray[a] = new int[b];
                b = 1;
                a++;
            }
        }

        for (int a = 0, b = 0, c = 0; c < lengthOfList; c++) {
            if (c == lengthOfList - 1) {
                numsIn2DArray[a][b] = allNums1DArray[c];
            } else if (allNums1DArray[c] < allNums1DArray[c + 1]) {
                numsIn2DArray[a][b] = allNums1DArray[c];
                b++;
            } else {
                numsIn2DArray[a][b] = allNums1DArray[c];
                a++;
                b = 0;
            }
        }

        return IntList2.list(numsIn2DArray);
    }

    /* Returns the number of ints in the IntList
     * that is being sent to the method.
     * A helper method for naturalRuns method. */
    static int countLength(IntList L, int currentLength) {
        if (L.tail == null) {
            return currentLength;
        } else {
            return countLength(L.tail, currentLength + 1);
        }
    }

    /* Returns an IntList starting from the int that is being sent in.
     * This code is being reused from Lab2, Question 2b.
     */
    static IntList subTail(IntList L, int start) {
        if (start == 0) {
            return L;
        } else {
            return subTail(L.tail, (start - 1));
        }

    }

    /* Returns a 1D array of ints that contains
     * all of the ints inside of the sent IntList.
     * A helper method for the naturalRuns method. */
    static int[] intListArrayConverter(IntList L, int length) {
        int[] items = new int[length];
        for (int a = 0; a < length; a++) {
            items[a] = subTail(L, a).head;
        }

        return items;
    }

    public static void main(String[] args) {        
    }


}
