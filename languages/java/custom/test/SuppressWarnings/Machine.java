import java.util.List;
import java.util.ArrayList;

public class Machine {
    @SuppressWarnings("rawtypes")
    private List versions;

    // Test case 1: Single string value
    @SuppressWarnings("unchecked")
    public void addVersion(String version) {
        versions.add(version);
    }

    // Test case 2: Array of string values
    @SuppressWarnings({"unchecked", "deprecation"})
    public void addMultipleVersions(String... newVersions) {
        for (String v : newVersions) {
            versions.add(v);
        }
    }

    // Test case 3: On class level
    @SuppressWarnings("serial")
    class InnerClass extends ArrayList<String> {
        public void doSomething() {
            // implementation
        }
    }

    // Test case 4: On field
    @SuppressWarnings("unused")
    private String unusedField;

    // Test case 5: On constructor
    @SuppressWarnings({"deprecation", "unchecked"})
    public Machine() {
        versions = new ArrayList();
    }

    // Test case 6: Multiple annotations with SuppressWarnings
    @Override
    @SuppressWarnings("rawtypes")
    public String toString() {
        return "Machine with versions";
    }

    // Test case 7: Empty SuppressWarnings
    @SuppressWarnings({})
    public void emptyWarnings() {
        // do nothing
    }

    // Test case 8: Single value in array
    @SuppressWarnings({"unchecked"})
    public void singleValueInArray() {
        versions.add("test");
    }
}

// Test case 9: On package-private class
@SuppressWarnings("all")
class AnotherMachine {
    public void method() {
        // implementation
    }
}

// Test case 10: Method without SuppressWarnings (should not be detected)
class CleanMachine {
    public void cleanMethod() {
        // no warnings to suppress
    }
}
