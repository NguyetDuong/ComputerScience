// This file contains a SUGGESTION for the structure of your program.  You
// may change any of it, or add additional files to this directory (package),
// as long as you conform to the project specification.

// Comments that start with "//" are intended to be removed from your
// solutions.
package jump61;

import static jump61.Side.*;
import static jump61.Square.square;
import java.util.ArrayList;

/** A Jump61 board state that may be modified.
 *  @author Nguyet Duong
 */
class MutableBoard extends Board {
	private int _size;
	private Square[][] _board;
	private int numMoves;
	private ArrayList<MutableBoard> history = new ArrayList<MutableBoard>();

    /** An N x N board in initial configuration. */
    MutableBoard(int N) {
        _size = N;
        _board = new Square[N][N];
        numMoves = 0;
        clearBoard();
        // FIXME
        // Remember that for this, it will ALWAYS start at 0. 
        // Hence addSpot(), and other things -- need to minus 1! 
        // !Fixed
    }
    
    /** This is to be used in the beginning step, where the
     * 	whole board is filled with WHITE-sides and only one dot
     *  in the middle. 
     *  
     *  This is a HELPER method to the MutableBoard(int N) constructor.
     */
    void clearBoard() {
    	for (int r = 0; r < _size; r++) {
    		for (int c = 0; c < _size; c++) {
    			Square x = Square.INITIAL;
    			_board[r][c] = x;
    		}
    	}
    }

    /** A board whose initial contents are copied from BOARD0, but whose
     *  undo history is clear. */
    MutableBoard(Board board0) {
    	_size = board0.size();
    	numMoves = 0;
    	_board = copyBoard(board0);
        // FIXME
    	// !fixed
    }
    
    /** This will take in a Board and take everything inside
     *  that board and transfer it onto a Square[][] (the basis for 
     *  an actual MutableBoard).
     *  
     *  This is a HELPER method to the MutableBoard(Board board0) constructor.
     *  
     * @param x
     * @return toReturn
     */
    Square[][] copyBoard(Board x) {
    	int size = x.size();
    	int pos = 0;
    	Square[][] toReturn = new Square[size][size];
    	for (int r = 0; r < size; r++) {
    		for (int c = 0; c < size; c++) {
    			toReturn[r][c] = x.get(pos);
    			pos++;
    		}
    	}
    	return toReturn;
    }

    @Override
    void clear(int N) {
        // FIXME
    	// !Fixed
    	_board = new Square[N][N];
    	_size = N;
    	numMoves = 0;
    	history = new ArrayList<MutableBoard>();
    	clearBoard();
        announce();
    }

    @Override
    void copy(Board board) {
        // FIXME
    	// !Fixed
    	_size = board.size();
    	_board = copyBoard(board);
    }
    /** Copy the contents of BOARD into me, without modifying my undo
     *  history.  Assumes BOARD and I have the same size. */
    private void internalCopy(MutableBoard board) {
        // FIXME
    	// !Fixed
    	_board = copyBoard(board);
    }

    @Override
    /** If the size of the board is N x N, it should
     *  return N.
     */
    int size() {
        // REPLACE WITH SOLUTION 
    	// !Replaced
        return _size;
    }

    @Override
    /** Return the square in position n, where the board
     *  is positioned like this:
     *  0 1 2 3 4
     *  5 6 7 8 9
     *  etc. etc.
     */
    Square get(int n) {
        // REPLACE WITH SOLUTION
    	// !Replaced
        return _board[row(n) - 1][col(n) - 1];
    }

    @Override
    int numOfSide(Side side) {
        // REPLACE WITH SOLUTION
    	// !Replaced
    	int nums = 0;
    	for (int r = 0; r < _size; r++) {
    		for (int c = 0; c < _size; c++) {
    			Side check = _board[r][c].getSide();
    			if (side.equals(check)) {
    				nums++;
    			}
    		}
    	}
        return nums;
    }

    @Override
    int numPieces() {
        // REPLACE WITH SOLUTION
    	// !Replaced
    	int nums = 0;
    	for (int r = 0; r < _size; r++) {
    		for (int c = 0; c < _size; c++) {
    			Square sq = _board[r][c];
    			nums+= sq.getSpots();
    		}
    	}
        return nums;
    }

    @Override
    void addSpot(Side player, int r, int c) {
    	markUndo();
        // FIXME
    	// !Fixed
    	if (!isOverfull(r, c)) {
    		Square copy = get(r, c);
    		int newSpots = copy.getSpots() + 1;
    		_board[r - 1][c - 1] = copy.square(player, newSpots);
    	} else {
    		// This is the break case so that it does not go into an infinite-loop
    		// Seeing the game is over as soon as all the dots took over the whole
    		// Board, essentially... 
    		Square copy = get(r, c);
    		int newSpots = copy.getSpots() + 1;
    		if (numOfSide(player) == _size * _size) {
    			return; 
    		} else if (!splitable(newSpots, r, c)) {
    			_board[r - 1][c - 1] = copy.square(player, newSpots);
    		} else {
    			_board[r - 1][c - 1] = copy.square(player, 1);
    			putOtherSpots(r, c, player);
    		}
    	}
        announce();
    }
    /** This is the addSpot(...) helper in order for us to be better at
     *  keeping track of the Undo option! This does exactly the same thing as
     *  addSpot(...) with the exception that this is a continuation of addSpot(...)
     *  where it is still on the same turn while addSpot(...) indicates a new turn.
     * @param player
     * @param r
     * @param c
     */
    void addSpotHelper(Side player, int r, int c) {
    	if (!isOverfull(r, c)) {
    		Square copy = get(r, c);
    		int newSpots = copy.getSpots() + 1;
    		_board[r - 1][c - 1] = copy.square(player, newSpots);
    	} else {
    		// This is the break case so that it does not go into an infinite-loop
    		// Seeing the game is over as soon as all the dots took over the whole
    		// Board, essentially... 
    		Square copy = get(r, c);
    		int newSpots = copy.getSpots() + 1;
    		if (numOfSide(player) == _size * _size) {
    			return; 
    		} else if (!splitable(newSpots, r, c)) {
    			_board[r - 1][c - 1] = copy.square(player, newSpots);
    		} else {
    			_board[r - 1][c - 1] = copy.square(player, 1);
    			putOtherSpots(r, c, player);
    		}
    	}
        announce();
    }
    
    /** This is to called when we are to add one into all the
     *  Squares around the Square in the position (r, c). 
     * @param r
     * @param c
     * @param s
     */
    void putOtherSpots(int r, int c, Side s) {
    	if (r == 1) {
    		if (c == 1) {
    			addSpotHelper(s, r, c + 1);
    			addSpotHelper(s, r + 1, c);
    		} else if (c == _size) {
    			addSpotHelper(s, r, c - 1);
    			addSpotHelper(s, r+ 1, c);
    		} else {
    			addSpotHelper(s, r, c - 1);
    			addSpotHelper(s, r + 1, c);
    			addSpotHelper(s, r, c + 1);
    		}
    	} else if (r == _size) {
    		if (c == 1) {
    			addSpotHelper(s, r - 1, c);
    			addSpotHelper(s, r, c + 1);
    		} else if (c == _size) {
    			addSpotHelper(s, r - 1, c);
    			addSpotHelper(s, r, c - 1);
    		} else {
    			addSpotHelper(s, r - 1, c);
    			addSpotHelper(s, r, c + 1);
    			addSpotHelper(s, r, c - 1);
    		}
    	} else if (c == 1) {
    		addSpotHelper(s, r - 1, c);
    		addSpotHelper(s, r, c + 1);
    		addSpotHelper(s, r + 1, c);
    	} else if (c == _size) {
    		addSpotHelper(s, r - 1, c);
    		addSpotHelper(s, r, c + 1);
    		addSpotHelper(s, r, c - 1);
    	} else {
    		addSpotHelper(s, r - 1, c);
    		addSpotHelper(s, r, c + 1);
    		addSpotHelper(s, r, c - 1);
    		addSpotHelper(s, r + 1, c);
    	}
    }

    @Override
    void addSpot(Side player, int n) {
        // FIXME
    	// !Fixed
    	addSpot(player, row(n), col(n));
        announce();
    }
    /** Returns true if the number of spots is greater than
     *  the amount of neighbors around the Square containing
     *  these spots. The reason for this is, there must be greater
     *  than the neighbors to put one in every neighboring square.
     *  
     * @param spots
     * @param r
     * @param c
     * @return boolean
     */
    boolean splitable(int spots, int r, int c) {
    	return spots > neighbors(r, c);
    }
    
    /** This is a helper method for addSpots(...) where it will
     *  return true if, when added another spot onto the current solution,
     *  the spot will become "overfull" -- bigger #of spots than
     *  all the Squares around it.
     * @param r
     * @param c
     * @return boolean
     */
    boolean isOverfull(int r, int c) {
		Square actual = get(r, c);
    	if (r == 1) {
    		if (c == 1) {
    			Square toRight = get(r, c + 1);
    			Square toBottom = get(r + 1, c);
    			return (spotsBigger(actual, toRight)
    					&& spotsBigger(actual, toBottom));
    		} else if (c == _size) {
    			Square toLeft = get(r, c - 1);
    			Square toBottom = get(r + 1, c);
    			return (spotsBigger(actual, toLeft)
    					&& spotsBigger(actual, toBottom));
    		} else {
    			Square toLeft = get(r, c - 1);
    			Square toBottom = get(r + 1, c);
    			Square toRight = get(r, c + 1);
    			return (spotsBigger(actual, toLeft)
    					&& spotsBigger(actual, toBottom)
    					&& spotsBigger(actual, toRight));
    		}
    	} else if (r == _size) {
    		if (c == 1) {
    			Square toTop = get(r - 1, c);
    			Square toRight = get(r, c + 1);
    			return (spotsBigger(actual, toRight)
    					&& spotsBigger(actual, toTop));
    		} else if (c == _size) {
    			Square toTop = get(r - 1, c);
    			Square toLeft = get(r, c - 1);
    			return (spotsBigger(actual, toLeft)
    					&& spotsBigger(actual, toTop));
    		} else {
    			Square toTop = get(r - 1, c);
    			Square toRight = get(r, c + 1);
    			Square toLeft = get(r, c - 1);
    			return (spotsBigger(actual, toLeft)
    					&& spotsBigger(actual, toTop)
    					&& spotsBigger(actual, toRight));
    		}
    	} else if (c == 1) {
    		Square toTop = get(r - 1, c);
    		Square toRight = get(r, c + 1);
    		Square toBottom = get(r + 1, c);
    		return (spotsBigger(actual, toBottom)
					&& spotsBigger(actual, toTop)
					&& spotsBigger(actual, toRight));
    	} else if (c == _size) {
    		Square toTop = get(r - 1, c);
    		Square toRight = get(r, c + 1);
    		Square toLeft = get(r, c - 1);
    		return (spotsBigger(actual, toLeft)
					&& spotsBigger(actual, toTop)
					&& spotsBigger(actual, toRight));
    	} else {
    		Square toTop = get(r - 1, c);
    		Square toRight = get(r, c + 1);
    		Square toLeft = get(r, c - 1);
    		Square toBottom = get(r + 1, c);
    		return (spotsBigger(actual, toLeft)
					&& spotsBigger(actual, toTop)
					&& spotsBigger(actual, toRight)
					&& spotsBigger(actual, toBottom));
    	}
    }
    
    /** This is a helper method for isOverFull(...) where it takes
     *  in two Squares, and then compare the two Squares -- returning
     *  true if the amount of spots in Square a is bigger than the amount
     *  of spots in Square b.
     * @param a
     * @param b
     * @return true if the spots in A is > spots in B
     */
    boolean spotsBigger(Square a, Square b){
    	return (a.getSpots() + 1) > b.getSpots();
    }
    @Override
    void set(int r, int c, int num, Side player) {
        internalSet(sqNum(r, c), square(player, num));
    }

    @Override
    void set(int n, int num, Side player) {
        internalSet(n, square(player, num));
        announce();
    }

    @Override
    void undo() {
        // FIXME
    	// !Fixed
    	numMoves--;
    	Board redo = history.get(numMoves);
    	history.remove(numMoves);
    	copy(redo);
    }

    /** Record the beginning of a move in the undo history. */
    private void markUndo() {
        // FIXME
    	// !Fixed
    	MutableBoard copy = new MutableBoard(this);
    	history.add(copy);
    	numMoves++;
    }

    /** Set the contents of the square with index IND to SQ. Update counts
     *  of numbers of squares of each color.  */
    private void internalSet(int ind, Square sq) {
        // FIXME
    	// !Fixed
    	_board[row(ind) - 1][col(ind) - 1] = sq;
    }

    /** Notify all Observers of a change. */
    private void announce() {
        setChanged();
        notifyObservers();
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof MutableBoard)) {
            return obj.equals(this);
        } else {
            // REPLACE WITH SOLUTION
        	// !Replaced
        	MutableBoard copy = (MutableBoard) obj;
        	if (copy.size() != this.size()) {
        		return false;
        	} else {
        		int numbers = _size * _size - 1;
        		for (int x = 0; x <= numbers; x++) {
        			Square a = this.get(x);
        			Square b = copy.get(x);
        			if (a.getSpots() != b.getSpots()
        					|| !a.getSide().equals(b.getSide())) {
        				return false;
        			}
        		}
        	}
            return true;
        }
    }

    @Override
    public int hashCode() {
        // REPLACE WITH SOLUTION.  RETURN A NUMBER THAT IS THE SAME FOR BOARDS
        // WITH IDENTICAL CONTENTS (IT NEED NOT BE DIFFERENT IF THE BOARDS
        // DIFFER.)  THE CURRENT STATEMENT WORKS, BUT IS NOT PARTICULARLY
        // EFFICIENT.
        return 0;
    }

}