package jump61;

/** A Player that gets its moves from manual input.
 *  @author Nguyet Duong
 */
class HumanPlayer extends Player {

    /** A new player initially playing COLOR taking manual input of
     *  moves from GAME's input source. */
    HumanPlayer(Game game, Side color) {
        super(game, color);
    }

    @Override
    /** Retrieve moves using getGame().getMove() until a legal one is found and
     *  make that move in getGame().  Report erroneous moves to player. */
    void makeMove() {
    	int[] positions = new int[2];
    	if (getGame().getMove(positions)) {
    		getGame().makeMove(positions[0], positions[1]);
    	}
    }
    /** This is the human move. Just a filler. */
    void makeMoveHuman() {
    	int[] positions = new int[2];
    	if (getGame().getMove(positions)) {
            getGame().makeMove(positions[0], positions[1]);
    	}
    }
    /** Returns the type of Player this is. */
    @Override
    String type() {
        return "Human";
    }

}