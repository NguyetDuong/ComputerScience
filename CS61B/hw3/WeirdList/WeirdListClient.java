/** Functions to increment and sum the elements of a WeirdList. */
class WeirdListClient {
    /** Part 2b. Returns the result of adding N to each element of L. */
    static WeirdList add(WeirdList L, int n) {
        return L.add(n); // REPLACE THIS LINE WITH THE RIGHT ANSWER.
    }

    /** Part 2c. Optional problem: Returns the sum of the elements in L */
    static int sum(WeirdList L) {
        return 0; // REPLACE THIS LINE WITH THE RIGHT ANSWER.
    }

    // As with WeirdList, you'll need to add an additional class or
    // perhaps more for WeirdListClient to work. And you may put
    // those classes either inside WeirdListClient as private static
    // classes, or in their own separate files.

    // You are still forbidden from using any of the following:
    //       if, switch, while, for, do, try, or the ?: operator.

    public static void main(String[] args) {
        WeirdList wl1 = new WeirdList(5, WeirdList.EMPTY);
        WeirdList wl2 = new WeirdList(6, wl1);
        WeirdList wl3 = new WeirdList(10, wl2);

        add(wl3, 4).print();
    }
}
