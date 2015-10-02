package db61b;

import java.util.ArrayList;

/** Represents a single 'where' condition in a 'select' command.
 *  Note: I rewrote this class and did not use the one was
 *  given to me.
 *  @author Nguyet Duong */
class Condition {
    /** A Condition will take in a ArrayList of Strings that
     *  contains up to the word 'and'. The ArrayList should
     *  only have 3 items inside of it. A column we're looking
     *  at, the conditional statement, and the item we're
     *  comparing it to.
     *  @param  conditions
     */
    Condition(ArrayList<String> conditions) {
        columnNotice = conditions.get(0);
        conditional = conditions.get(1);
        String a = conditions.get(2);
        if (a.contains("'")) {
            hasQ = true;
            comparison = a.substring(1, conditions.get(2).length() - 1).trim();
        } else {
            hasQ = false;
            comparison = a;
        }
        
    }

    /** Will return true if inputs are equal to each
     *  other at some instance, and passes the
     *  conditionalHelper.
     *  @param  change
     *  @param  columnNames
     */
    Boolean getConditionalRow(Row change, Row columnsNames) {
        String identity = "";
        String c = "";
        Boolean exists = false;
        for (int i = 0; i < columnsNames.size(); i++) {
            if (columnsNames.get(i).equals(comparison)) {
                exists = true;
            }
        }

        if (!hasQ) {
            for (int i = 0; i < columnsNames.size(); i++) {
                Boolean a = columnNotice.equals(columnsNames.get(i));
                if (columnNotice.equals(columnsNames.get(i))) {
                    identity = change.get(i);
                } 
                if (comparison.equals(columnsNames.get(i))) {
                    c = change.get(i);
                }
            }
        } else {
            for (int i = 0; i < columnsNames.size(); i++) {
                Boolean a = columnNotice.equals(columnsNames.get(i));
                if (columnNotice.equals(columnsNames.get(i))) {
                    identity = change.get(i);
                    c = comparison;
                    break;
                }
            }
        }
        return conditionalHelper(identity, c);
    }
    /** Will return true if the relations to
     *  the our input "comparison" is correct.
     *  @param  i
     */
    Boolean conditionalHelper(String i, String x) {
        if (conditional.equals("=")) {
            return (x.compareTo(i) == 0);
        } else if (conditional.equals(">=")) {
            return (x.compareTo(i) <= 0);
        } else if (conditional.equals(">")) {
            return (x.compareTo(i) < 0);
        } else if (conditional.equals("<=")) {
            return (x.compareTo(i) >= 0);
        } else if (conditional.equals("<")) {
            return (x.compareTo(i) > 0);
        } else if (conditional.equals("!=")) {
            return (x.compareTo(i) != 0);
        } else {
            return false;
        }
    }

    String comparison() {
        return comparison;
    }

    /** This saves which column we are looking at. */
    private String columnNotice;
    /** This saves what our relation is. */
    private String conditional;
    /** This saves which what we are comparing to. */
    private String comparison;
    /** This saves whether or not if the comparison
     *  can even be made. */
    private Boolean hasQ;
}