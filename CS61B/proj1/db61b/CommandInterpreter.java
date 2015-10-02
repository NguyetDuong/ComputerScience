package db61b;

import java.io.PrintStream;

import java.util.ArrayList;
import java.util.Scanner;

import static db61b.Utils.*;
import static db61b.Tokenizer.*;

/** An object that reads and interprets a sequence of commands from an
 *  input source.
 *  @author Nguyet Duong */
class CommandInterpreter {

    /* STRATEGY.
     *
     *   This interpreter parses commands using a technique called
     * "recursive descent." The idea is simple: we convert the BNF grammar,
     * as given in the specification document, into a program.
     *
     * First, we break up the input into "tokens": strings that correspond
     * to the "base case" symbols used in the BNF grammar.  These are
     * keywords, such as "select" or "create"; punctuation and relation
     * symbols such as ";", ",", ">="; and other names (of columns or tables).
     * All whitespace and comments get discarded in this process, so that the
     * rest of the program can deal just with things mentioned in the BNF.
     * The class Tokenizer performs this breaking-up task, known as
     * "tokenizing" or "lexical analysis."
     *
     * The rest of the parser consists of a set of functions that call each
     * other (possibly recursively, although that isn't needed for this
     * particular grammar) to operate on the sequence of tokens, one function
     * for each BNF rule. Consider a rule such as
     *
     *    <create statement> ::= create table <table name> <table definition> ;
     *
     * We can treat this as a definition for a function named (say)
     * createStatement.  The purpose of this function is to consume the
     * tokens for one create statement from the remaining token sequence,
     * to perform the required actions, and to return the resulting value,
     * if any (a create statement has no value, just side-effects, but a
     * select clause is supposed to produce a table, according to the spec.)
     *
     * The body of createStatement is dictated by the right-hand side of the
     * rule.  For each token (like create), we check that the next item in
     * the token stream is "create" (and report an error otherwise), and then
     * advance to the next token.  For a metavariable, like <table definition>,
     * we consume the tokens for <table definition>, and do whatever is
     * appropriate with the resulting value.  We do so by calling the
     * tableDefinition function, which is constructed (as is createStatement)
     * to do exactly this.
     *
     * Thus, the body of createStatement would look like this (_input is
     * the sequence of tokens):
     *
     *    _input.next("create");
     *    _input.next("table");
     *    String name = name();
     *    Table table = tableDefinition();
     *    _input.next(";");
     *
     * plus other code that operates on name and table to perform the function
     * of the create statement.  The .next method of Tokenizer is set up to
     * throw an exception (DBException) if the next token does not match its
     * argument.  Thus, any syntax error will cause an exception, which your
     * program can catch to do error reporting.
     *
     * This leaves the issue of what to do with rules that have alternatives
     * (the "|" symbol in the BNF grammar).  Fortunately, our grammar has
     * been written with this problem in mind.  When there are multiple
     * alternatives, you can always tell which to pick based on the next
     * unconsumed token.  For example, <table definition> has two alternative
     * right-hand sides, one of which starts with "(", and one with "as".
     * So all you have to do is test:
     *
     *     if (_input.nextIs("(")) {
     *         _input.next("(");
     *         // code to process "<column name>,  )"
     *     } else {
     *         // code to process "as <select clause>"
     *     }
     *
     * As a convenience, you can also write this as
     *
     *     if (_input.nextIf("(")) {
     *         // code to process "<column name>,  )"
     *     } else {
     *         // code to process "as <select clause>"
     *     }
     *
     * combining the calls to .nextIs and .next.
     *
     * You can handle the list of <column name>s in the preceding in a number
     * of ways, but personally, I suggest a simple loop:
     *
     *     ... = columnName();
     *     while (_input.nextIs(",")) {
     *         _input.next(",");
     *         ... = columnName();
     *     }
     *
     * or if you prefer even greater concision:
     *
     *     ... = columnName();
     *     while (_input.nextIf(",")) {
     *         ... = columnName();
     *     }
     *
     * (You'll have to figure out what do with the names you accumulate, of
     * course).
     */


    /** A new CommandInterpreter executing commands read from INP, writing
     *  prompts on PROMPTER, if it is non-null. */
    CommandInterpreter(Scanner inp, PrintStream prompter) {
        _input = new Tokenizer(inp, prompter);
        _database = new Database();
    }

    /** Parse and execute one statement from the token stream.  Return true
     *  iff the command is something other than quit or exit. */
    boolean statement() {
        switch (_input.peek()) {
        case "create":
            createStatement();
            break;
        case "load":
            loadStatement();
            break;
        case "exit": case "quit":
            exitStatement();
            return false;
        case "*EOF*":
            return false;
        case "insert":
            insertStatement();
            break;
        case "print":
            printStatement();
            break;
        case "select":
            selectStatement();
            break;
        case "store":
            storeStatement();
            break;
        default:
            throw error("unrecognizable command");
        }
        return true;
    }

    /** Parse and execute a create statement from the token stream. */
    void createStatement() {
        _input.next("create");
        _input.next("table");
        String name = name();
        Table table = tableDefinition();
        _database.put(name, table);
        _input.next(";");
    }

    /** Parse and execute an exit or quit statement. Actually does nothing
     *  except check syntax, since statement() handles the actual exiting. */
    void exitStatement() {
        if (!_input.nextIf("quit")) {
            _input.next("exit");
        }
        _input.next(";");
    }

    /** Parse and execute an insert statement from the token stream. */
    void insertStatement() {
        _input.next("insert");
        _input.next("into");
        Table table = tableName();
        _input.next("values");

        ArrayList<String> values = new ArrayList<>();
        values.add(literal());
        while (_input.nextIf(",")) {
            values.add(literal());
        }
        if (table.columns() == values.size()) {
            table.add(new Row(values.toArray(new String[values.size()])));
            _input.next(";");
        } else{
            throw error("inserted row has wrong length");
        }
    }

    /** Parse and execute a load statement from the token stream.
     *  DONE */
    void loadStatement() {
        String nameOfLoad = _input.next();
        nameOfLoad = _input.next();
        Table a = Table.readTable(nameOfLoad);
        _database.put(nameOfLoad, a);
        System.out.printf("Loaded " + nameOfLoad + ".db %n");
        _input.next(";");
    }

    /** Parse and execute a store statement from the token stream. */
    void storeStatement() {
        _input.next("store");
        String name = _input.peek();
        Table table = tableName();
        table.writeTable(name);
        System.out.printf("Stored %s.db%n", name);
        _input.next(";");
    }

    /** Parse and execute a print statement from the token stream.
     *  DONE */
    void printStatement() {
        String nameOfPrinted = _input.next();
        nameOfPrinted = _input.next();
        Table a = _database.get(nameOfPrinted);
        if (a != null) {
            System.out.printf("Contents of " + nameOfPrinted + ": %n");
            a.print();
        } else {
            throw error("unknown table: %s", nameOfPrinted);
        }
        _input.next(";");

    }

    /** Parse and execute a select statement from the token stream. */
    void selectStatement() {
        ArrayList<String> requestedCols = new ArrayList<String>();
        ArrayList<String> columnNames = new ArrayList<String>();
        ArrayList<Table> tableNames = new ArrayList<Table>();

        Table toPrint;
        while (!_input.nextIs(";")) {
            String a = _input.next();
            requestedCols.add(a);
        }

        Boolean hasCondition = requestedCols.contains("where");
        int indexFrom = requestedCols.indexOf("from");
        for (int i = 1; i < indexFrom; i++) {
            if (!requestedCols.get(i).equals(",")) {
                columnNames.add(requestedCols.get(i));
            }
        }

        if (indexFrom == -1) {
            throw error("command is incorrect");
        }

        if (hasCondition) {
            ArrayList<Condition> condition = new ArrayList<Condition>();
            int pos = requestedCols.indexOf("where");

            for (int i = indexFrom + 1; i < pos; i++) {
                if (!requestedCols.get(i).equals(",")) {
                    Table a = _database.get(requestedCols.get(i));
                    if (a != null && !tableNames.contains(a)) {
                        tableNames.add(a);
                    } else if (a == null) {
                        throw error("unknown table: %s", a);
                    }
                }
            }

            if (!(columnExists(columnNames, tableNames) == -1)) {
                throw error("unknown column: %s",
                    columnNames.get(columnExists(columnNames, tableNames)));
            }

            ArrayList<String> cons = new ArrayList<String>();
            for (int i = pos + 1; i < requestedCols.size(); i++) {
                if (requestedCols.get(i).equals("and")) {
                    condition.add(new Condition(cons));
                    cons.clear();
                    i++;
                }
                cons.add(requestedCols.get(i));
            }
            condition.add(new Condition(cons));

            if (sameColumns(columnNames, tableNames)) {
                System.out.printf("Search results: %n");
                for (int i = 0; i < tableNames.size(); i++) {
                    toPrint = tableNames.get(i).select(columnNames, condition);
                    toPrint.print();
                }

                _input.next(";");
            } else {
                if (tableNames.size() > 2) {
                    throw error("Maximum table number should be 2");
                } else {
                    System.out.printf("Search results: %n");
                    if (tableNames.get(0).size() >= tableNames.get(1).size()) {
                        Table x = tableNames.get(0);
                        toPrint = x.select(tableNames.get(1),
                            columnNames, condition);
                        toPrint.print();
                    } else {
                        Table x = tableNames.get(1);
                        toPrint = x.select(tableNames.get(0),
                            columnNames, condition);
                        toPrint.print();
                    }
                    _input.next(";");
                }
            }

        } else {
            ArrayList<Condition> conditions = new ArrayList<Condition>();
            for (int i = indexFrom + 1; i < requestedCols.size(); i++) {
                if (!requestedCols.get(i).equals(",")) {
                    Table a = _database.get(requestedCols.get(i));
                    if (a != null && !tableNames.contains(a)) {
                        tableNames.add(a);
                    } else if (a == null) {
                        throw error("unknown table: %s", a);
                    }
                }
            }

            if (!(columnExists(columnNames, tableNames) == -1)) {
                throw error("unknown column: %s",
                    columnNames.get(columnExists(columnNames, tableNames)));
            }
            if (sameColumns(columnNames, tableNames)) {
                System.out.printf("Search results: %n");
                for (int i = 0; i < tableNames.size(); i++) {
                    toPrint = tableNames.get(i).select(columnNames, conditions);
                    toPrint.print();
                }
                _input.next(";");
            } else {
                if (tableNames.size() > 2) {
                    throw error("Maximum table number should be 2");
                } else {
                    System.out.printf("Search results: %n");
                    if (tableNames.get(0).size() >= tableNames.get(1).size()) {
                        Table x = tableNames.get(0);
                        toPrint = x.select(tableNames.get(1),
                            columnNames, conditions);
                        toPrint.print();
                    } else {
                        Table x = tableNames.get(1);
                        toPrint = x.select(tableNames.get(0),
                            columnNames, conditions);
                        toPrint.print();
                    }
                    _input.next(";");
                }
            }
        }
    }

    /** Returns true if all of the columns' names
     *  exists in all of the tables.
     *  @param  col
     *  @param  tables */
    Boolean sameColumns(ArrayList<String> col, ArrayList<Table> tables) {
        for (int a = 0; a < tables.size(); a++) {
            for (int b = 0; b < col.size(); b++) {
                Table c = tables.get(a);
                if (c.findColumn(col.get(b)) == -1) {
                    return false;
                }
            }
        }
        return true;
    }

    /** Parse and execute a table definition, returning the specified
     *  table. */
    Table tableDefinition() {
        Table table;
        ArrayList<String> a = new ArrayList<String>();
        if (_input.nextIs("(")) {
            while (!_input.nextIs(")")) {
                if (!_input.nextIs(",")  && !_input.nextIs("(")) {
                    a.add(_input.next());
                } else {
                    _input.next();
                }
            }
            String[] b = new String[a.size()];
            for (int i = 0; i < a.size(); i++) {
                b[i] = a.get(i);
            }
            table = new Table(b);
            _input.next();
        } else {
            while (!_input.nextIs(";")) {
                if (!_input.nextIs(",")) {
                    a.add(_input.next());
                } else {
                    _input.next();
                }
            }
            int startingPos = a.indexOf("select") + 1;
            Boolean hasCondition = a.contains("where");
            int indexFrom = a.indexOf("from");
            ArrayList<String> columns = new ArrayList<String>();
            ArrayList<Table> tables = new ArrayList<Table>();
            ArrayList<Condition> conditions = new ArrayList<Condition>();
            if (indexFrom == -1) {
                throw error("command is incorrect");
            }
            for (int i = startingPos; i < indexFrom; i++) {
                columns.add(a.get(i));
            }
            if (!hasCondition) {

                for (int i = indexFrom + 1; i < a.size(); i++) {
                    tables.add(_database.get(a.get(i)));
                }

                if (tables.size() == 1) {
                    table = tables.get(0).select(columns, conditions);
                } else if (tables.size() > 2) {
                    throw error("please input only 2 tables");
                } else if (sameColumns(columns, tables)) {
                    Table x = tables.get(0).select(columns, conditions);
                    Table y = tables.get(1).select(columns, conditions);
                    table = x.mergeTable(y, columns);
                } else {
                    if (tables.get(0).size() >= tables.get(1).size()) {
                        Table x = tables.get(0);
                        table = x.select(tables.get(1), columns, conditions);
                    } else {
                        Table x = tables.get(1);
                        table = x.select(tables.get(0), columns, conditions);
                    }
                }

            } else {
                int indexWhere = a.indexOf("where");
                for (int i = indexFrom + 1; i < indexWhere; i++) {
                    tables.add(_database.get(a.get(i)));
                }
                ArrayList<String> cons = new ArrayList<String>();
                for (int i = indexWhere + 1; i < a.size(); i++) {
                    if (a.get(i).equals("and")) {
                        conditions.add(new Condition(cons));
                        cons.clear();
                        i++;
                    }
                    cons.add(a.get(i));
                }
                conditions.add(new Condition(cons));

                if (tables.size() == 1) {
                    table = tables.get(0).select(columns, conditions);
                } else if (tables.size() > 2) {
                    throw error("please input only 2 tables");
                } else if (sameColumns(columns, tables)) {
                    Table x = tables.get(0).select(columns, conditions);
                    Table y = tables.get(1).select(columns, conditions);
                    table = x.mergeTable(y, columns);
                } else {
                    if (tables.get(0).size() >= tables.get(1).size()) {
                        Table x = tables.get(0);
                        table = x.select(tables.get(1), columns, conditions);
                    } else {
                        Table x = tables.get(1);
                        table = x.select(tables.get(0), columns, conditions);
                    }
                }
            }
        }
        return table;
    }

    /** This acts as a boolean case while returning
     *  the column that does not exist.
     */
    int columnExists(ArrayList<String> col, ArrayList<Table> tables) {
        int tableSize = tables.size();
        if (tableSize == 1) {
            Table a = tables.get(0);
            for (int i = 0; i < col.size(); i++) {
                if (a.findColumn(col.get(i)) == -1) {
                    return i;
                }
            }
            return -1;
        } else {
            Table a = tables.get(0);
            Table b = tables.get(1);
            for (int i = 0; i < col.size(); i++) {
                if (a.findColumn(col.get(i)) == -1 &&
                    b.findColumn(col.get(i)) == -1) {
                    return i;
                }
            }
            return -1;
        }
    }

    /** Parse and execute a select clause from the token stream, returning the
     *  resulting table. */
    Table selectClause() {
        return null;

    }

    /** Parse and return a valid name (identifier) from the token stream. */
    String name() {
        return _input.next(Tokenizer.IDENTIFIER);
    }

    /** Parse and return a valid column name from the token stream. Column
     *  names are simply names; we use a different method name to clarify
     *  the intent of the code. */
    String columnName() {
        return name();
    }

    /** Parse a valid table name from the token stream, and return the Table
     *  that it designates, which must be loaded. */
    Table tableName() {
        String name = name();
        Table table = _database.get(name);
        if (table == null) {
            throw error("unknown table: %s", name);
        }
        return table;
    }

    /** Parse a literal and return the string it represents (i.e., without
     *  single quotes). */
    String literal() {
        String lit = _input.next(Tokenizer.LITERAL);
        return lit.substring(1, lit.length() - 1).trim();
    }

    /** Parse and return a list of Conditions that apply to TABLES from the
     *  token stream.  This denotes the conjunction (`and') zero
     *  or more Conditions. */
    ArrayList<Condition> conditionClause(Table... tables) {
        return null;
    }

    /** Parse and return a Condition that applies to TABLES from the
     *  token stream. */
    Condition condition(Table... tables) {
        return null;
    }

    /** Advance the input past the next semicolon. */
    void skipCommand() {
        while (true) {
            try {
                while (!_input.nextIf(";") && !_input.nextIf("*EOF*")) {
                    _input.next();
                }
                return;
            } catch (DBException excp) {
                /* No action */
            }
        }
    }
    /** The command input source. */
    private Tokenizer _input;
    /** Database containing all tables. */
    private Database _database;
}
