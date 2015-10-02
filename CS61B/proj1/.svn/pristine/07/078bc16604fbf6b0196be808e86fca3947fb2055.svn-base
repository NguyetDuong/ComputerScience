package db61b;
import java.util.HashMap;

/** A collection of Tables, indexed by name.
 *  @author Nguyet Duong
 */
class Database {
    /** An empty database.
     *  DONE */
    public Database() {
        _keys = new HashMap<String, Table>();
    }

    /** Return the Table whose name is NAME stored in this database, or null
     *  if there is no such table. */
    public Table get(String name) {
        return _keys.get(name);
    }

    /** Set or replace the table named NAME in THIS to TABLE.  TABLE and
     *  NAME must not be null, and NAME must be a valid name for a table. */
    public void put(String name, Table table) {
        if (name == null || table == null) {
            throw new IllegalArgumentException("null argument");
        }
        _keys.put(name, table);
    }
    /** This holds all of the keys
     *  and the corrisponding table to it. */
    private HashMap<String, Table> _keys;
}
