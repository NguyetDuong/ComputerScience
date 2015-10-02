package graph;

import java.util.HashMap;

/* See restrictions in Graph.java. */

/** A partial implementation of ShortestPaths that contains the weights of
 *  the vertices and the predecessor edges.   The client needs to
 *  supply only the two-argument getWeight method.
 *  @author Nguyet Duong
 */
public abstract class SimpleShortestPaths extends ShortestPaths {

    /** The shortest paths in G from SOURCE. */
    public SimpleShortestPaths(Graph G, int source) {
        this(G, source, 0);
        _weights = new HashMap<Integer, Double>();
    }

    /** A shortest path in G from SOURCE to DEST. */
    public SimpleShortestPaths(Graph G, int source, int dest) {
        super(G, source, dest);
        _weights = new HashMap<Integer, Double>();
    }

    @Override
    public double getWeight(int v) {
        if (!_weights.containsKey(v) && !getGraph().contains(v)) {
            return Double.MAX_VALUE;
        }
        return _weights.get(v);
    }

    @Override
    protected void setWeight(int v, double w) {
        _weights.put(v, w);
    }

    @Override
    public int getPredecessor(int v) {
        if (!getMoves().containsKey(v)) {
            return 0;
        }
        return getMoves().get(v);
    }

    @Override
    protected void setPredecessor(int v, int u) {
        getMoves().put(v, u);
    }

    /** It is a HashMap take has the vertex as its key,
     *  and weight as its value.
     */
    private HashMap<Integer, Double> _weights;
}
