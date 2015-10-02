package graph;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;

import static org.junit.Assert.*;

/** Unit tests for the Graph class.
 *  @author Nguyet Duong
 */
public class DirectAndUndirectGraphTesting {

    @Test
    public void directedEdgeTest() {
    	DirectedGraph g = new DirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	ArrayList<Integer> out = new ArrayList<Integer>();
    	for (int[] i : g.edges()) {
    		out.add(i[0]);
    		out.add(i[1]);
    	}
    	List<Integer> correct = Arrays.asList(4, 1, 1, 4, 1, 2, 2, 3, 3, 2, 2, 4);
    	assertEquals(correct, out);
    }

    @Test
    public void undirectedEdgeTest() {
    	UndirectedGraph g = new UndirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	ArrayList<Integer> out = new ArrayList<Integer>();
    	for (int[] i : g.edges()) {
    		out.add(i[0]);
    		out.add(i[1]);
    	}
    	List<Integer> correct = Arrays.asList(4, 1, 1, 2, 2, 3, 2, 4);
    	assertEquals(correct, out);
    }

    @Test
    public void directedInDegree() {
    	DirectedGraph g = new DirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	g.add(4, 2);
    	assertEquals(0, g.inDegree(10));
    	assertEquals(1, g.inDegree(1));
    	assertEquals(2, g.inDegree(4));
    	assertEquals(3, g.inDegree(2));
    	assertEquals(0, g.inDegree(5));
    }

    @Test
    public void indirectInDegree() {
    	UndirectedGraph g = new UndirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	assertEquals(0, g.inDegree(7));
    	assertEquals(3, g.inDegree(2));
    	assertEquals(2, g.inDegree(4));
    	assertEquals(0, g.inDegree(5));
    	assertEquals(2, g.inDegree(1));
    	assertEquals(1, g.inDegree(3));
    }

    @Test
    public void directedPrecessors() {
    	DirectedGraph g = new DirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(1, 3);
    	g.add(3, 2);
    	g.add(2, 1);
    	g.add(4, 2);
    	g.add(4, 1);
    	assertEquals(1, g.predecessor(3, 0));
    	assertEquals(0, g.predecessor(3, 3));
    	assertEquals(2, g.predecessor(1, 0));
    	assertEquals(4, g.predecessor(1, 1));
    }

    @Test
    public void directedPrecessorsList() {
    	DirectedGraph g = new DirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(1, 3);
    	g.add(3, 2);
    	g.add(2, 1);
    	g.add(4, 2);
    	g.add(4, 1);
    	g.add(3, 1);
    	g.add(1, 3);
    	g.add(2, 3);
    	List<Integer> correct = Arrays.asList(2, 4, 3);
    	ArrayList<Integer> out = new ArrayList<Integer>();
    	for (int i : g.predecessors(1)) {
    		out.add(i);
    	}
    	assertEquals(correct, out);
    	List<Integer> correct2 = Arrays.asList(1, 2);
    	ArrayList<Integer> out2 = new ArrayList<Integer>();
    	for (int i : g.predecessors(3)) {
    		out2.add(i);
    	}
    	assertEquals(correct2, out2);
    }

    @Test
    public void undirectedPrecessors() {
    	UndirectedGraph g = new UndirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	g.add(2, 2);
    	g.add(4, 4);
    	assertEquals(4, g.predecessor(1, 0));
    	assertEquals(0, g.predecessor(5, 0));
    	assertEquals(3, g.predecessor(2, 1));
    	assertEquals(1, g.predecessor(4, 0));
    	assertEquals(2, g.predecessor(4, 1));
    	assertEquals(4, g.predecessor(4, 2));
    }

    @Test
    public void undirectedPrecessorsList() {
    	UndirectedGraph g = new UndirectedGraph();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add();
    	g.add(4, 1);
    	g.add(1, 4);
    	g.add(1, 2);
    	g.add(2, 3);
    	g.add(3, 2);
    	g.add(2, 4);
    	g.add(2, 2);
    	g.add(4, 4);
    	List<Integer> correct = Arrays.asList(4, 2);
    	ArrayList<Integer> out = new ArrayList<Integer>();
    	for (int c : g.predecessors(1)) {
    		out.add(c);
    	}
    	assertEquals(correct, out);
    	List<Integer> correct2 = Arrays.asList(1, 2, 4);
    	ArrayList<Integer> out2 = new ArrayList<Integer>();
    	for (int c : g.predecessors(4)) {
    		out2.add(c);
    	}
    	assertEquals(correct2, out2);
    } 
}
