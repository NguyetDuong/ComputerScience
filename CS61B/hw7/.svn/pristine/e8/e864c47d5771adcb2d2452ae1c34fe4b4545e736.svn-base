import java.util.LinkedList;

public class ECHashStringSet implements StringSet {
	/** This uses a HashTable to hold a
	 *	strings in an efficient way -- as in 
	 *	resize HashTable if loadFactor > 5
	 *	and all loadFact > 0.2 unless it is an empty list.
	 *
	 *	If hashCode() < 0, remove top bit using bit operations.
	 */

	private int items;
	private int size;
	private LinkedList<String>[] bucket = new LinkedList[5];

	public ECHashStringSet() {
		items = 0;
		size = bucket.length;
	}

	private Boolean needToResize() {
		double x = (double) items/size;
		if (items == 0) {
			return false;
		} else if (x > 5 || x < 0.2) {
			return true;
		} else {
			return false;
		}
	}

	public void put(String s) {
		if (!contains(s)) {
			int hashCode = s.hashCode();
			if (hashCode < 0) {
				hashCode = ~hashCode + 1;
			}
			int pos = hashCode % size;
			if (bucket[pos] == null) {
				LinkedList<String> x = new LinkedList();
				x.add(s);
				items++;
				bucket[pos] = x;
			} else {
				LinkedList<String> x = bucket[pos];
				x.add(s);
				items++;
				bucket[pos] = x;
			}

			if (needToResize()) {
				this.bucket = reDoItemList();
			} 
		}
		
	}

	private LinkedList<String>[] reDoItemList() {
		int newSize = size * 2;
		LinkedList<String>[] newBucket = new LinkedList[newSize];
		for (int a = 0; a < bucket.length; a++) {
			if (bucket[a] != null) {
				LinkedList<String> ll = bucket[a];
				for (String i : ll) {
					int hashCode = i.hashCode();
					if (hashCode < 0) {
						hashCode = ~hashCode + 1;
					}
					int pos = hashCode % size;
					if (newBucket[pos] == null) {
						LinkedList<String> cc = new LinkedList();
						cc.add(i);
						newBucket[pos] = cc;
					} else {
						LinkedList<String> cc = newBucket[pos];
						cc.add(i);
						newBucket[pos] = cc;
					}
				}
			}
		}
		size = newSize;
		return newBucket;
	}

	public boolean contains(String s) {
		int hashCode = s.hashCode();
		if (hashCode < 0) {
			hashCode = ~hashCode + 1;
		}
		int pos = hashCode % size;
		if (bucket[pos] == null) {
			return false;
		} else {
			return bucket[pos].contains(s);
		}
	}

}