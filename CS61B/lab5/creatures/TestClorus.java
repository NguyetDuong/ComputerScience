package creatures;
import org.junit.Test;
import static org.junit.Assert.*;
import java.util.HashMap;
import java.awt.Color;
import huglife.Direction;
import huglife.Action;
import huglife.Occupant;
import huglife.Impassible;
import huglife.Empty;

/** Tests the clorus class   
 *  @author FIXME
 */

public class TestClorus {
    @Test
    public void testChoose() {
        Clorus clorusA = new Clorus(1.7);
        HashMap<Direction, Occupant> mapA = new HashMap<Direction, Occupant>();
        mapA.put(Direction.TOP, new Impassible());
        mapA.put(Direction.BOTTOM, new Impassible());
        mapA.put(Direction.LEFT, new Impassible());
        mapA.put(Direction.RIGHT, new Impassible());
        Action testARun = clorusA.chooseAction(mapA);
        Action testAActual = new Action(Action.ActionType.STAY);
        assertEquals(testAActual, testARun);

        Clorus clorusB = new Clorus(1.2);
        HashMap<Direction, Occupant> mapB = new HashMap<Direction, Occupant>();
        mapB.put(Direction.TOP, new Impassible());
        mapB.put(Direction.BOTTOM, new Impassible());
        mapB.put(Direction.LEFT, new Empty());
        mapB.put(Direction.RIGHT, new Impassible());
        Action testBRun = clorusB.chooseAction(mapB);
        Action testBActual = new Action(Action.ActionType.REPLICATE, Direction.LEFT);
        assertEquals(testBActual, testBRun);

        Clorus clorusC = new Clorus(1.6);
        HashMap<Direction, Occupant> mapC = new HashMap<Direction, Occupant>();
        mapC.put(Direction.TOP, new Impassible());
        mapC.put(Direction.BOTTOM, new Plip(1.4));
        mapC.put(Direction.LEFT, new Empty());
        mapC.put(Direction.RIGHT, new Impassible());
        Action testCRun = clorusC.chooseAction(mapC);
        Action testCActual = new Action(Action.ActionType.ATTACK, Direction.BOTTOM);
        assertEquals(testCActual, testCRun);

        Clorus clorusD = new Clorus(1.7);
        HashMap<Direction, Occupant> mapD = new HashMap<Direction, Occupant>();
        mapD.put(Direction.TOP, new Impassible());
        mapD.put(Direction.BOTTOM, new Plip(1));
        mapD.put(Direction.LEFT, new Impassible());
        mapD.put(Direction.RIGHT, new Impassible());
        Action testDRun = clorusD.chooseAction(mapD);
        Action testDActual = new Action(Action.ActionType.STAY);
        assertEquals(testDActual, testDRun);


    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(TestClorus.class));
    }
} 
