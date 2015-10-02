package graph;

import java.util.ArrayList;

/* See restrictions in Graph.java. */

/** Represents an undirected graph.  Out edges and in edges are not
 *  distinguished.  Likewise for successors and predecessors.
 *
 *  @author
 */
public class UndirectedGraph extends GraphObj {

    @Override
    public boolean isDirected() {
        return false;
    }

    @Override
    public int inDegree(int v) {
        // FIXME -- FIXED
    	if (!contains(v)) {
    		return 0;
    	} else {
    		int numsOfDeg = 0;
    		Iteration<int[]> obj = edges();
    		for (int[] c : obj) {
        		if (c[0] == v || c[1] == v) {
        			numsOfDeg++;
        		}
        	}
	    		
    		return numsOfDeg;
    	}
    }

    @Override
    public int predecessor(int v, int k) {
        // FIXME -- FIXED
    	Iteration<int[]> obj = edges();
    	for (int[] c : obj) {
    		if (c[0] == v) {
    			if (k == 0) {
    				return c[1];
    			} else {
    				k--;
    			}
    		} else if (c[1] == v) {
    			if (k == 0) {
    				return c[0];
    			} else {
    				k--;
    			}
    		}
    	}
        return 0;
    }

    @Override
    public Iteration<Integer> predecessors(int v) {
        // FIXME
    	Iteration<int[]> obj = edges();
    	ArrayList<Integer> correct = new ArrayList<Integer>();
    	for (int[] c: obj) {
    		if (c[0] == v) {
    			correct.add(c[1]);
    		} else if (c[1] == v) {
    			correct.add(c[0]);
    		}
    	}
    	Iteration<Integer> re = new Iterate<Integer>(correct.iterator());
        return re;
    }

    // FIXME

}
