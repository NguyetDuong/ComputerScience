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

/** Tests the plip class   
 *  @authr FIXME
 */

public class TestPlip {

    @Test
    public void testBasics() {
        Plip p = new Plip(2);
        assertEquals(2, p.energy(), 0.01);
        assertEquals(new Color(99, 255, 76), p.color());
        p.move();
        assertEquals(1.85, p.energy(), 0.01);
        p.move();
        assertEquals(1.70, p.energy(), 0.01);
        p.stay();
        assertEquals(1.90, p.energy(), 0.01);
        p.stay();
        assertEquals(2.00, p.energy(), 0.01);
    }

    @Test
    public void testReplicate() {
        Plip mom = new Plip(1.4);
        mom.move();
        assertEquals(1.25, mom.energy(), 0.01);
        Plip baby = mom.replicate();
        assertEquals(0.625, mom.energy(), 0.01);
        assertEquals(0.625, baby.energy(), 0.01);
        assertNotSame(baby, mom);
    }

    @Test
    public void testChoose() {
        Plip p = new Plip(1.2);
        HashMap<Direction, Occupant> surrounded = new HashMap<Direction, Occupant>();
        surrounded.put(Direction.TOP, new Impassible());
        surrounded.put(Direction.BOTTOM, new Impassible());
        surrounded.put(Direction.LEFT, new Impassible());
        surrounded.put(Direction.RIGHT, new Impassible());

        //You can create new empties with new Empty();
        //Despite what the spec says, you cannot test for Cloruses nearby yet.
        //Sorry!  

        Action actual = p.chooseAction(surrounded);
        Action expected = new Action(Action.ActionType.STAY);
        assertEquals(expected, actual);

        //Test Number 2
        Plip b = new Plip(1.2);
        HashMap<Direction, Occupant> map = new HashMap<Direction, Occupant>();
        map.put(Direction.TOP, new Impassible());
        map.put(Direction.BOTTOM, new Impassible());
        map.put(Direction.LEFT, new Impassible());
        map.put(Direction.RIGHT, new Empty());

        Action get = b.chooseAction(map);
        Action real = new Action(Action.ActionType.REPLICATE, Direction.RIGHT);
        assertEquals(real, get);
    }

    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(TestPlip.class));
    }
} 
