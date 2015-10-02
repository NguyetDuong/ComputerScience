package graph;

import org.junit.Test;

import static org.junit.Assert.*;

/** Unit tests for the Graph class.
 *  @author Nguyet Duong
 */
public class LabeledGraphTesting {

    @Test
    public void labeledGraphLabelsTests() {
        UndirectedGraph ggNoRe = new UndirectedGraph();
        LabeledGraph<Integer, Double> g
            = new LabeledGraph<Integer, Double>(ggNoRe);
        g.add();
        g.add();
        g.add();
        g.add();
        g.add();
        g.add(3, 3);
        g.add(4, 1, 10.2);
        g.add(2, 2);
        g.add(1, 2, 812.1);
        assertEquals(true, 10.2 == g.getLabel(4, 1));
        assertEquals(true, g.contains(1, 4));
        Double b = g.getLabel(1, 4);
        assertEquals(true, 10.2 == b);
        assertEquals(null, g.getLabel(2, 2));
        assertEquals(true, 812.1 == g.getLabel(1, 2));
    }

}
