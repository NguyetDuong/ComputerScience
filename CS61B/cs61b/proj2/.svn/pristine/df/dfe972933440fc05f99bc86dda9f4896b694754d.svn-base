
package jump61;

import java.util.ArrayList;

/** An automated Player.
 *  @author Nguyet Duong
 */
class AI extends Player {

    /** Time allotted to all but final search depth (milliseconds). */
    private static final long TIME_LIMIT = 15000;

    /** Number of calls to minmax between checks of elapsed time. */
    private static final long TIME_CHECK_INTERVAL = 10000;

    /** Number of milliseconds in one second. */
    private static final double MILLIS = 1000.0;

    /** A new player of GAME initially playing COLOR that chooses
     *  moves automatically.
     */
    AI(Game game, Side color) {
        super(game, color);
    }

    @Override
    void makeMove() {
        ArrayList<Integer> empty = new ArrayList<Integer>();
        MutableBoard c = new MutableBoard(getBoard());
        int item = minmax(getSide(), c, 4, INF, empty, -1);
        getGame().makeMove(item);
        if (getSide() == Side.RED) {
        	System.out.println("Red moves " + getBoard().row(item)
                     + " " + getBoard().col(item) + ".");
        } else {
        	System.out.println("Blue moves " + getBoard().row(item)
                    + " " + getBoard().col(item) + ".");
        }

    }
    /** This is when we have two AI. */
    void makeMoveHuman() {
        ArrayList<Integer> empty = new ArrayList<Integer>();
        MutableBoard c = new MutableBoard(getBoard());
        int item = minmax(getSide(), c, 4, INF, empty, 0);
        getGame().makeMove(item);

        if (getSide() == Side.RED) {
        	System.out.println("Red moves " + getBoard().row(item)
                     + " " + getBoard().col(item) + ".");
        } else {
        	System.out.println("Blue moves " + getBoard().row(item)
                    + " " + getBoard().col(item) + ".");
        }
    }
    /** This will return the first valid move for this player, on this board.
     * @return int[] with row being at 0, and col being at 1
     */
    private int[] findValidMoves() {
        int[] places = new int[2];
        for (int r = 1; r <= getBoard().size(); r++) {
            for (int c = 1; c <= getBoard().size(); c++) {
                if (getBoard().isLegal(getSide(), r, c)) {
                    places = new int[] {r, c};
                    return places;
                }
            }
        }
        return places;
    }

    @Override
    String type() {
        return "AI";
    }
    /** Return the minimum of CUTOFF and the minmax value of board B
     *  (which must be mutable) for player P to a search depth of D
     *  (where D == 0 denotes statically evaluating just the next move).
     *  If MOVES is not null and CUTOFF is not exceeded, set MOVES to
     *  a list of all highest-scoring moves for P; clear it if
     *  non-null and CUTOFF is exceeded. the contents of B are
     *  invariant over this call.
     *  Thought process: minmax will return the maximum value at ALL times --
     *  I need to configure this so that it will return the 
     *  MINIMUM value when it is
     *  my opponent's turn. Can be done with a negative in front?
     *  I get my moves from moves arraylist at the top because
     *  I will be adding in
     *  all the steps I took to get to where I went...
     *  */
    private int minmax(Side p, Board b, int d,
            int cutoff, ArrayList<Integer> moves,
            int bestPosition) {
        Side o = p.opposite();
        int totalSq = b.size() * b.size();
        if (b.getWinner() == p) {
            return INF;
        } else if (b.getWinner() == o) {
            return NINF;
        } else if (d == 0) {
            return guessBestMove(p, b, cutoff, moves, -1);
        }

        int bestMoveValue = worstMove(p, b);
        for (int n = 0; n < totalSq; n++) {
            if (b.isLegal(p, n)) {
                b.addSpot(p, n);
                int opponent = minmax(o, b, d - 1, -bestMoveValue, moves, -1);
                if (-opponent > bestMoveValue) {
                    bestPosition = n;
                    bestMoveValue = -opponent;
                    if (bestMoveValue >= cutoff) {
                        b.undo();
                        break;
                    }
                }
                moves.add(bestPosition);
                b.undo();
            }
        }
        return bestPosition;
    }
    /** This will return the highest heuristic value, given
     *  the side p and board b. On top of that, it will revise the
     *  ArrayList moves given to it so that the ArrayList now contains
     *  the moves taken to get there.
     * @param p
     * @param b
     * @param moves
     * @return highest heuristic value given the Side p and Board b
     */
    private int guessBestMove(Side p, Board b,
    		int cutoff, ArrayList<Integer> moves,
            int bestPosition) {
        int bestCase = NINF;
        int totalSq = b.size() * b.size();
        for (int n = 0; n < totalSq; n++) {
            if (b.isLegal(p, n)) {
                b.addSpot(p, n);
                int currentCase = staticEval(p, b);
                if (currentCase > bestCase) {
                    bestCase = currentCase;
                    bestPosition = n;
                    if (bestCase >= cutoff) {
                        b.undo();
                        break;
                    }
                }
                b.undo();
            }
        }
        return bestPosition;
    }

    /** Given a board and the side we're calculating the worstMove for
     *  we look through every single possible move, then return the move
     *  that gives the LEAST amount of staticEval -- points
     * @param p
     * @param b
     * @return the least heuristic value for board b and player p
     */
    private int worstMove(Side p, Board b) {
        int totalSq = b.size() * b.size();
        int worstCase = INF;
        for (int n = 0; n < totalSq; n++) {
            if (b.isLegal(p, n)) {
                b.addSpot(p, n);
                if (worstCase > staticEval(p, b)) {
                    worstCase = staticEval(p, b);
                }
                b.undo();
            }
        }
        return worstCase;
    }

    /** Returns heuristic value of board B for player P.
     *  Higher is better for P.
     *  Essentially return the number of P squares
     *  - number of opp(P) squares. */
    private int staticEval(Side p, Board b) {
        Side opp = p.opposite();
        int mySide = 0;
        int oppSide = 0;
        for (int r = 1; r <= b.size(); r++) {
            for (int c = 1; c <= b.size(); c++) {
                if (b.get(r, c).getSide() == p) {
                    mySide++;
                } else if (b.get(r, c).getSide() == opp) {
                    oppSide++;
                }
            }
        }
        return mySide - oppSide;
    }
    /** This is my version of infinity */
    private static final int INF = 10000000;
    /** This is my version of negative infinity */
    private static final int NINF = -10000000;

}
