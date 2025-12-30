# Usage of @SuppressWarnings annotation

## Description

This query detects all uses of the Java `@SuppressWarnings` annotation in the codebase.

## Recommendation

The `@SuppressWarnings` annotation is used to suppress compiler warnings. While it can be useful in specific situations, overuse of this annotation may hide important warnings that could indicate real issues in the code.

Consider:

- Only using `@SuppressWarnings` when absolutely necessary
- Documenting why warnings are being suppressed
- Reviewing suppressed warnings periodically to see if they can be addressed properly
- Using specific warning types rather than suppressing all warnings

## Example

```java
public class Machine {
    private List versions;

    // Single string value
    @SuppressWarnings("unchecked")
    public void addVersion(String version) {
        versions.add(version);
    }

    // Array of string values
    @SuppressWarnings({"unchecked", "deprecation"})
    public void addMultipleVersions(String... newVersions) {
        for (String v : newVersions) {
            versions.add(v);
        }
    }
}
```

## References

- [Java Language Specification - Annotations](https://docs.oracle.com/javase/specs/jls/se8/html/jls-9.html#jls-9.6)
- [SuppressWarnings Annotation](https://docs.oracle.com/javase/8/docs/api/java/lang/SuppressWarnings.html)
