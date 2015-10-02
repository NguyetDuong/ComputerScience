/** Provides a variety of utilities for operating on matrices.
 *  All methods assume that the double[][] arrays provided are rectangular.
 *
 *  @author Josh Hug and YOU
 */

public class MatrixUtils {
    /** enum for specifying vertical vs. horizontal orientation
     *  You can use this, for example, by writing Orientation x = VERTICAL
     *
     *  If you're using this from another class, you'll need to use the class
     *  name as well, e.g. 
     *  MatrixUtils.Orientation x = MatrixUtils.Orientation.VERTICAL
     *
     *  See http://goo.gl/73xqAu for more.
     */

    static enum Orientation { VERTICAL, HORIZONTAL };

    /** Non-destructively accumulates an energy matrix in the vertical 
     *  direction.
     *
     *  Given an energy matrix M, returns a new matrix am[][] such that 
     *  for each index i, j, the value in am[i][j] is the minimum total 
     *  energy required to reach position i, j from any spot in the top
     *  row. See the bottom of this comment for an example.
     *
     *  Potentially useful methods: MatrixUtils.copy
     *
     *  A helper method you might consider writing:
     *    get(double[][] e, int r, int c): Returns the e[r][c] if
     *         r and c are valid. Double.POSITIVE_INFINITY otherwise
     *
     *  An example is shown below. See the assignment spec for a 
     *  detailed explanation of this example.
     *
     *  Sample input:
     *  1000000   1000000   1000000   1000000
     *  1000000     75990     30003   1000000
     *  1000000     30002    103046   1000000
     *  1000000     29515     38273   1000000
     *  1000000     73403     35399   1000000
     *  1000000   1000000   1000000   1000000
     *
     *  Output for sample input:
     *  1000000   1000000   1000000   1000000
     *  2000000   1075990   1030003   2000000
     *  2075990   1060005   1133049   2030003
     *  2060005   1089520   1098278   2133049
     *  2089520   1162923   1124919   2098278
     *  2162923   2124919   2124919   2124919
     *
     */

    public static double[][] accumulateVertical(double[][] m) {
        int row = m.length;
        int col = m[0].length;
        double[][] energy = new double[row][col];

        /** Will input all the energy of the first row
         *  because all of the energies in the first row are static.
         */
        for (int a = 0; a < row; a++) {
            for (int b = 0; a < col; b++) {
                energy[a][b] = leastEnergyHelper(m, a, b, 1);
            }
        }

        return energy;

    }

    /** Helper method for Question 3a. accumulateVertical.
     *
     *  This method will return a double that represents
     *  the least amount of energy it takes to get there.
     *  Using the matrix-array that is sent in, where
     *  i is the row and j is the column.
     *
     *  Note that i (the # of the row) also signifies how many
     *  steps we have to move around the grid.
     */
        public static double leastEnergyHelper(double[][] m, int i, int j, int round) {
        int lenOfRow = m[i].length;
        if (round == 1) {
            if (i == 0) {
                return m[i][j];
            } else {
                if (j == 0) {
                    System.out.println("new i = " + (i - 1) + " new j = " + (j + columnPositionMove(m[i][j], m[i][j + 1], "right")));
                    return m[i][j] +
                    leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j], m[i - 1][j + 1], "right"), 0);
                } else if (j == lenOfRow - 1) {
                    return m[i][j] +
                    leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j], m[i - 1][j - 1], "left"), 0);
                } else {
                    return m[i][j] +
                    leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j - 1], m[i - 1][j], m[i - 1][j + 1]), 0);
                }
            }
        } else {
            if (i == 0) {
                return m[i][j];
            } else if (j == 0) {
                return m[i][j] +
                leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j - 1], m[i][j + 1], "right"), 0);
            } else if (j == lenOfRow - 1) {
                return m[i][j] +
                leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j], m[i - 1][j - 1], "left"), 0);
            } else {
                return m[i][j] +
                leastEnergyHelper(m, i - 1, j + columnPositionMove(m[i - 1][j - 1], m[i - 1][j], m[i - 1][j + 1]), 0);
            }
        }
    }
        
    /** Helper method for Question 3a. accumulateVertical.
     *
     *  This is going to be used in LeastEnergyHelper.
     *  It will take at least two doubles and at most three doubles: left, mid, and right.
     *  Then comparing the three doubles, this method will return
     *  the double with the lowest energy level.
     */
    public static double lowestEnergyLevel(double left, double mid, double right) {
        if (left < mid && left < right) {
            return left;
        } else if (mid <= left && mid <= right) {
            return mid;
        } else {
            return right;
        }
    }
    public static double lowestEnergyLevel(double a, double b) {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }

    /** Helper method for Question 3a. accumulateVerticle.
     *
     *  This is very similar to lowestEnergyLevel but instead of
     *  returning the double that is considered the "lowest,"
     *  we return either -1 for left, 0 for mid, and +1 for right.
     *  This will help me with the method leastEnergyHelper to
     *  figure out which column we are on now.
     */

    public static int columnPositionMove(double left, double mid, double right) {
        double lowestEnergy = lowestEnergyLevel(left, mid, right);
        if (lowestEnergy == left) {
            return -1;
        } else if (lowestEnergy == mid) {
            return 0;
        } else {
            return 1;
        }
    }

    public static int columnPositionMove(double mid, double c, String r) {
        double lowestEnergy = lowestEnergyLevel(mid, c);
        if (lowestEnergy == mid) {
            return 0;
        } else if (lowestEnergy != mid && r == "left") {
            return -1;
        } else {
            return 1;
        }
    }


    /** Non-destructively accumulates a matrix M along the specified
     *  ORIENTATION.
     *
     *  If the orientation is Orientation.VERTICAL, function is identical to
     *  accumulateVertical. If Orientation.HORIZONTAL, function is
     *  the same, but with roles of r and c reversed.
     *
     *  Do NOT copy and paste a bunch of code! Instead, you should write
     *  a helper function that creates a new matrix mT that contains all
     *  the information from m, but with the property that
     *  accumulateVertical(mT) returns the correct result.
     *
     *  accumulate should be very short (only a few lines). Most of the
     *  work should be done in creaing the helper function (and even
     *  that function should be pretty short and straightforward).
     *
     *  The important lesson here is that you should never have big
     *  copy and pastes of any code. Instead, find the right
     *  abstraction that lets you avoid this mess. You'll need to do this
     *  for project 1, but in a more complex way.
     *
     */

    public static double[][] accumulate(double[][] m, Orientation orientation) {
        if (orientation == Orientation.VERTICAL) {
            return accumulateVertical(m);
        } else {
            int row = m.length;
            int col = m[0].length;

            double[][] n = new double[col][row];
            for (int a = 0; a < col; a++) {
                for (int b = 0; b < row; b++) {
                    n[a][b] = m[b][a];
                }
            }
            return accumulateVertical(n);
        }

    }

    /** Finds the vertical seam VERTSEAM of the given matrix M.
     *
     *  Potentially useful helper function: Something that takes
     *  an array, a lo index, and a hi index, and returns the
     *  index of the smallest thing in that array between those
     *  indices (inclusive).
     *
     *  Such a helper function will keep your code simple.
     *
     *  To keep the HW from getting too long, this method (and the
     *  next) is optional. however, completing it will allow you to
     *  see the resizing algorithm (that you wrote!) in action.
     *
     *  Sample input:
     *  1000000   1000000   1000000   1000000
     *  2000000   1075990   1030003   2000000
     *  2075990   1060005   1133049   2030003
     *  2060005   1089520   1098278   2133049
     *  2089520   1162923   1124919   2098278
     *  2162923   2124919   2124919   2124919
     *
     *  Output for sameple input: {1, 2, 1, 1, 2, 1}.
     *  See 4x6.png.verticalSeam.correct for a visual picture.
     *
     *  This answer is NOT unique. There are other correct seams.
     *  One way to test seam correctness is to check that the
     *  total energy is approximately equal.
     */

    public static int[] findVerticalSeam(double[][] m) {
        //your code here
        return null;
    }

    /** Returns the SEAM of M with the given ORIENTATION.
     *  As with accumulate, this should be really short and use
     *  a helper method.
     */

    public static int[] findSeam(double[][] m, Orientation orientation) {
        //your code here
        return null;

    }

    /** does nothing. ARGS not used. use for whatever purposes you'd like */
    public static void main(String[] args) {
        /* sample calls to functions in this class are below

        ImageRescaler sc = new ImageRescaler("4x6.png");

        double[][] em = ImageRescaler.energyMatrix(sc);

        //double[][] m = sc.cumulativeEnergyMatrix(true);
        double[][] m = MatrixUtils.accumulateVertical(em);
        System.out.println(MatrixUtils.matrixToString(em));
        System.out.println();

        double[][] ms = MatrixUtils.accumulate(em, Orientation.HORIZONTAL);

        System.out.println(MatrixUtils.matrixToString(m));
        System.out.println();
        System.out.println(MatrixUtils.matrixToString(ms));


        int[] lep = MatrixUtils.findVerticalSeam(m);

        System.out.println(seamToString(m, lep, Orientation.VERTICAL));

        int[] leps = MatrixUtils.findSeam(ms, Orientation.HORIZONTAL);

        System.out.println(seamToString(ms, leps, Orientation.HORIZONTAL));
        */

        double[][] test = new double[][] {
            {10, 12, 34, 25, 6},
            {24, 5, 34, 23, 64},
            {53, 64, 3, 54, 22},
            {2, 34, 3, 45, 23},
            {95, 34, 22, 46, 45}
        };

        double[][] a = new double[][] {
            {1000000, 1000000, 1000000, 1000000},
            {1000000, 75990, 30003, 1000000},
            {1000000, 30002, 103046, 1000000},
            {1000000, 29515, 38273, 1000000},
            {1000000, 73403, 35399, 1000000},
            {1000000, 1000000, 1000000, 1000000}
        };

        /*double[][] check = accumulateVertical(test);
        for (int a = 0; a < check[0].length; a++) {
            System.out.print(check[0][a] + " ");
        }*/

        //System.out.println(columnPositionMove(12.0, 8.0, "right"));
        //i == rows
        //j == col
        //System.out.println(a[0].length);
        System.out.println(leastEnergyHelper(a, 5, 3, 1));
        //System.out.println("Lowest Energy Level: " + lowestEnergyLevel(1000000, 75990, 30003));
        
        
    }


    /** Below follow some utility functions. Also see Utils.java. */

    /** Returns a string representaiton of the given matrix M.
     */

    public static String matrixToString(double[][] m) {
        int height = m.length;
        int width = m[0].length;
        StringBuilder sb = new StringBuilder();

        for (int r = 0; r < height; r++) {
            for (int c = 0; c < width; c++) {
                sb.append(String.format("%9.0f ", m[r][c]));
            }

            sb.append("\n");
        }
        return sb.toString();
    }

    /** Returns a copy of the matrix M. Note that it is probably a better idea
     *  to use System.arraycopy for general 2D arrays since
     */

    public static double[][] copy(double[][] m) {
        int height = m.length;
        int width = m[0].length;

        double[][] copy = new double[height][];
        for (int r = 0; r < height; r++) {
            copy[r] = new double[width];
            double[] thisRow = m[r];
            System.arraycopy(thisRow, 0, copy[r], 0, width);
        }
        return copy;
    }

    /** Checks to see if a given SEAM is valid given a particular
     *  image HEIGHT, WIDTH, and a seam ORIENTATION. Throws an illegal
     *  argument exception if invalid.
     */

    public static void validateSeam(int height, int width,
                           int[] seam, Orientation orientation) {

        if ((orientation == Orientation.VERTICAL)
             && (seam.length != height)) {
            throw new IllegalArgumentException("Bad vertical seam length.");
        }

        if ((orientation == Orientation.HORIZONTAL)
            && (seam.length != width)) {
            throw new IllegalArgumentException("Bad horizontal seam length.");
        }

        int maxValue;
        if (orientation == Orientation.VERTICAL) {
            maxValue = width - 1;
        } else {
            maxValue = height - 1;
        }


        for (int i = 0; i < seam.length; i++) {
            if (seam[i] < 0 || seam[i] >= maxValue) {
                String msg = "Seam value out of bounds.";
                throw new IllegalArgumentException(msg);
            }
        }

        for (int i = 0; i < seam.length - 1; i++) {
            int difference = Math.abs(seam[i] - seam[i + 1]);


            if (difference > 1) {
                String msg = "Seam not contiguous.";
                throw new IllegalArgumentException(msg);
            }
        }
    }


    /** Returns a string representation of  the matrix M annotated with the
     *  provided SEAM along the ORIENTATION specified.
     */

    public static String seamToString(double[][] m, int[] seam,
                                     Orientation orientation) {

        StringBuilder sb = new StringBuilder();
        int height = m.length;
        int width = m[0].length;

        validateSeam(height, width, seam, orientation);

        for (int r = 0; r < height; r++) {
            for (int c = 0; c < width; c++) {
                char lMarker = ' ';
                char rMarker = ' ';
                if (orientation == Orientation.VERTICAL) {
                    if (c == seam[r]) {
                        lMarker = '[';
                        rMarker = ']';
                    }
                } else {
                    if (r == seam[c]) {
                        lMarker = '[';
                        rMarker = ']';
                    }
                }
                sb.append(String.format("%c%6.0f%c ",
                          lMarker, m[r][c], rMarker));
            }
            sb.append("\n");
        }

        return sb.toString();
    }

}
