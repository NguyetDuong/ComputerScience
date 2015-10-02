/** An implementation of StringSet
 *	@author Nguyet Duong
 */

public class BSTStringSet implements StringSet {
	private String left;
	private BSTStringSet right;

	public BSTStringSet() {
		left = "EMPTY";
		right = null;
	}

	public boolean contains(String x) {
		while (!left.equals("EMPTY")) {
			if (left.equals(x)) {
				return true;
			} else {
				right.contains(x);
			}
		}

		return false;
	}

	public void put(String x) {
		if (left.equals(x)) {
			return;
		} else {
			if (left.equals("EMPTY")) {
				left = x;
				BSTStringSet c = new BSTStringSet();
				right = c;
			}
		}
	}

}