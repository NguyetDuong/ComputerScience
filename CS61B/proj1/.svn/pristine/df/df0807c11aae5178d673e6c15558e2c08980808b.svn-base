package db61b;
import org.junit.Test;
import static org.junit.Assert.*;
import java.util.ArrayList;

public class ProjectTester {
    /** This part is the testing for:
     *  Row Class */
    @Test
    public void testRowSize() {
        Row a = new Row(new String[]{"Hello", ", my", "name", "is", "Nguyet!"});
        assertEquals(5, a.size());
        Row b = new Row(new String[]{"", "I", "like", "pie"});
        assertEquals(4, b.size());
        Row c = new Row(new String[]{"", "I",
            "", "what?", "cannot", "hear", "you"});
        assertEquals(7, c.size());
    }

    @Test
    public void testRowGet() {
        Row a = new Row(new String[]{"Hello", ", my", "name", "is", "Nguyet!"});
        assertEquals(", my", a.get(1));
        assertEquals("name", a.get(2));
        Row c = new Row(new String[]{"", "I",
            "", "what?", "cannot", "hear", "you"});
        assertEquals("", c.get(0));
        assertEquals("you", c.get(6));
        assertEquals("", c.get(2));
    }

    @Test
    public void testRowEquals() {
        Row a = new Row(new String[]{"Hello", ", my", "name", "is", "Nguyet!"});
        Row a2 = new Row(new String[]{"Hello",
            ", my", "name", "is", "Nguyet!"});
        Row a3 = new Row(new String[]{"Hello", ", my", "name", "is", "Mimi!"});
        Object a4 = new String[]{"Hello", ", my", "name", "is", "Nguyet!"};
        Row c = new Row(new String[]{"", "I", "", "what?", "cannot", "hear", "you"});
        assertEquals(false, a.equals(a3));
        assertEquals(true, a.equals(a2));
        assertEquals(false, a.equals(a4));
        assertEquals(false, a.equals(c));
    }

    @Test
    public void testRowConstructor() {
        ArrayList<Column> a = new ArrayList<Column>();
        Row p1 = new Row(new String[]{"Lo", "2222", "2014", "AAS"});
        Row p2 = new Row(new String[]{"Li", "2342", "2015", "AAS"});
        Row p3 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        Row p4 = new Row(new String[]{"Zigg", "2123", "2014", "AAS"});
        Row p5 = new Row(new String[]{"Rai", "2123", "2014", "AAS"});
        Row p6 = new Row(new String[]{"Lom", "2123", "2014", "AAS"});
        Row p7 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        Table d = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        d.add(p1);
        d.add(p2);
        d.add(p3);
        d.add(p4);
        d.add(p5);
        d.add(p6);
        d.add(p7);
        a.add(new Column("Year", d));
        a.add(new Column("SID", d));
        Row x = new Row(a, p1);
        assertEquals("2014", x.get(0));
        assertEquals("2222", x.get(1));

    }

    /** This part is the testing for:
     *  Table Class */

    @Test
    public void testTableColumns() {
        Table a = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        Table b = new Table(new String[]{"Sugar",
            "Number", "Age", "Life", "Parents", "House"});
        assertEquals(4, a.columns());
        assertEquals(6, b.columns());
    }

    @Test
    public void testTableGetTitle() {
        Table a = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        assertEquals("Last Name", a.getTitle(0));
        assertEquals("Year", a.getTitle(2));
        assertEquals("Last Name", a.getTitle(0));
        assertEquals("SID", a.getTitle(1));
        Table b = new Table(new String[]{"Sugar", "Number",
            "Age", "Life", "Parents", "House"});
        assertEquals("Number", b.getTitle(1));
        assertEquals("Parents", b.getTitle(4));
        assertEquals("Age", b.getTitle(2));
    }

    @Test
    public void testTableFindColumn() {
        Table a = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        assertEquals(-1, a.findColumn("bob"));
        assertEquals(-1, a.findColumn(""));
        assertEquals(0, a.findColumn("Last Name"));
        assertEquals(2, a.findColumn("Year"));
        assertEquals(-1, a.findColumn("year"));
    }

    @Test
    public void testTableSize() {
        Table a = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        Row p1 = new Row(new String[]{"Lo", "2222", "2014", "AAS"});
        Row p2 = new Row(new String[]{"Li", "2342", "2015", "AAS"});
        Row p3 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        Row p4 = new Row(new String[]{"Zigg", "2123", "2014", "AAS"});
        Row p5 = new Row(new String[]{"Rai", "2123", "2014", "AAS"});
        Row p6 = new Row(new String[]{"Lom", "2123", "2014", "AAS"});
        Row p7 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        assertEquals(0, a.size());
        Table b = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        b.add(p1);
        b.add(p2);
        b.add(p3);
        b.add(p4);
        b.add(p5);
        assertEquals(5, b.size());
        Table c = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        c.add(p3);
        c.add(p4);
        c.add(p1);
        c.add(p3);
        assertEquals(3, c.size());
        Table d = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        d.add(p1);
        d.add(p2);
        d.add(p3);
        d.add(p4);
        d.add(p5);
        d.add(p6);
        d.add(p7);
        assertEquals(6, d.size());
    }

    @Test
    public void testTableAdd() {
        Table a = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        Row p1 = new Row(new String[]{"Lo", "2222", "2014", "AAS"});
        Row p2 = new Row(new String[]{"Li", "2342", "2015", "AAS"});
        Row p3 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        Row p4 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        assertEquals(true, a.add(p1));
        assertEquals(true, a.add(p2));
        assertEquals(true, a.add(p3));
        assertEquals(false, a.add(p4));
    }

    @Test
    public void testTableReadTable() {
        Table a = Table.readTable("enrolled");
        assertEquals(3, a.columns());
        assertEquals("CCN", a.getTitle(1));
        assertEquals(19, a.size());
        assertEquals(-1, a.findColumn("hello"));
        assertEquals(2, a.findColumn("Grade"));
    }

    /** This test was manually checked on the computer, and it passed */
    @Test
    public void testTableWriteTable() {
        Table a = new Table(new String[]{"Language",
            "Size", "Gender"});
        Row p1 = new Row(new String[]{"English", "S", "Female"});
        Row p2 = new Row(new String[]{"English", "L", "Male"});
        Row p3 = new Row(new String[]{"Spanish", "M", "Male"});
        a.add(p1);
        a.add(p2);
        a.add(p3);
        a.writeTable("rats");
        Table b = Table.readTable("rats");
        assertEquals("Language", b.getTitle(0));
        assertEquals("Size", b.getTitle(1));

    }

    /** Manually checked what printed when I ran this class, it passed */
    @Test
    public void testTablePrint() {
        Table a = new Table(new String[]{"Language",
            "T-Shirt", "Gender"});
        Row p1 = new Row(new String[]{"English", "S", "Female"});
        Row p2 = new Row(new String[]{"English", "L", "Male"});
        Row p3 = new Row(new String[]{"Spanish", "M", "Male"});
        a.add(p1);
        a.add(p2);
        a.add(p3);
    }

    /** Manually tested what printed when I ran the class, it passed */
    @Test
    public void testTableSelect1() {
        Table a = Table.readTable("enrolled");
        ArrayList<String> items = new ArrayList<String>();
        items.add("SID");
        items.add("Grade");
        ArrayList<Condition> conditions = new ArrayList<Condition>();
        Table b = a.select(items, conditions);
    }

    /** This part is testing for:
     *  Database */
    @Test
    public void testDatabasePutandSet() {
        Table a = new Table(new String[]{"Language",
            "T-Shirt", "Gender"});
        Row p1 = new Row(new String[]{"English", "S", "Female"});
        Row p2 = new Row(new String[]{"English", "L", "Male"});
        Row p3 = new Row(new String[]{"Spanish", "M", "Male"});
        a.add(p1);
        a.add(p2);
        a.add(p3);
        Table b = new Table(new String[]{"Last Name",
            "SID", "Year", "Courses"});
        Row p4 = new Row(new String[]{"Lo", "2222", "2014", "AAS"});
        Row p5 = new Row(new String[]{"Li", "2342", "2015", "AAS"});
        Row p6 = new Row(new String[]{"Gen", "2123", "2014", "AAS"});
        b.add(p4);
        b.add(p5);
        b.add(p6);

        Database tester = new Database();
        tester.put("Owners", a);
        tester.put("Students", b);
        assertEquals(a, tester.get("Owners"));
        assertEquals(b, tester.get("Students"));
        assertEquals(b.size(), tester.get("Students").size());
        assertEquals("Language", tester.get("Owners").getTitle(0));
    }

    /** This part is testing for:
     *  Condition */

    public void testCondition() {
        ArrayList<String> a = new ArrayList<String>();
        a.add("Grade");
        a.add("=");
        a.add("'B'");
        Row c = new Row(new String[]{"341", "22113", "B"});
        Row f = new Row(new String[]{"313", "25332", "B+"});
        Row e = new Row(new String[]{"SID", "CCN", "Grade"});
        Condition b = new Condition(a);
        assertEquals(true, b.getConditionalRow(c, e));
        assertEquals(false, b.getConditionalRow(f, e));
    }
    public static void main(String[] args) {
        System.exit(ucb.junit.textui.runClasses(ProjectTester.class));
    }
}