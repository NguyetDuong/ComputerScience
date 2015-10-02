package graph;

import java.util.ArrayList;

/* See restrictions in Graph.java. */

/** Represents a general unlabeled directed graph whose vertices are denoted by
 *  positive integers. Graphs may have self edges.
 *
 *  @author Nguyet Duong
 */
public class DirectedGraph extends GraphObj {

    @Override
    public boolean isDirected() {
        return true;
    }

    @Override
    public int inDegree(int v) {
        // FIXME -- FIXED
    	if (!contains(v)) {
    		return 0;
    	} else {
    		int numOfDegree = 0;
    		Iteration<int[]> edg = edges();
    		ArrayList<Integer> out = new ArrayList<Integer>();
        	for (int[] i : edg) {
        		out.add(i[0]);
        		out.add(i[1]);
        	}
        	for (int i = 1; i < out.size(); i += 2) {
        		if (out.get(i) == v) {
        			numOfDegree++;
        		}
        	}
    		return numOfDegree;
    	}
    }

    @Override
    public int predecessor(int v, int k) {
        // FIXME -- FIXED
    	Iteration<int[]> edg = edges();
		ArrayList<Integer> out = new ArrayList<Integer>();
    	for (int[] i : edg) {
    		out.add(i[0]);
    		out.add(i[1]);
    	}
    	for (int i = 1; i < out.size(); i += 2) {
    		if (out.get(i) == v) {
    			if (k == 0) {
    				return out.get(i - 1);
    			}
    			k--;
    		}
    	}
    	
        return 0;
    }

    @Override
    public Iteration<Integer> predecessors(int v) {
        // FIXME -- FIXED
    	Iteration<int[]> edg = edges();
		ArrayList<Integer> out = new ArrayList<Integer>();
		ArrayList<Integer> correct = new ArrayList<Integer>();
    	for (int[] i : edg) {
    		out.add(i[0]);
    		out.add(i[1]);
    	}
    	for (int i = 1; i < out.size(); i += 2) {
    		if (out.get(i) == v) {
    			correct.add(out.get(i - 1));
    		}
    	}
    	Iteration<Integer> re = new Iterate<Integer>(correct.iterator());
        return re;
    }

    // FIXME

}