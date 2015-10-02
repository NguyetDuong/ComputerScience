package graph;
import java.util.Iterator;

public class Iterate<Type> extends Iteration<Type> {
	
	Iterator<Type> _default;
	
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