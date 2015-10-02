package graph;
import java.util.Iterator;

/** This class is an implementation that extends Iterator.
 *  @author Nguyet Duong */
public class Iterate<Type> extends Iteration<Type> {
    /** This is the default iterator. */

    private Iterator<Type> _default;

    /** This is normal. */
    Iterate(Iterator<Type> inp) {
        _default = inp;
    }

    @Override
    public boolean hasNext() {
        return _default.hasNext();
    }

    @Override
    public Type next() {
        return _default.next();
    }
}
