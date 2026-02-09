/**
 * @name Logging of sensitive data
 * @description Detects when sensitive data (names, email addresses, passwords, phone numbers) is logged using logging frameworks
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision medium
 * @id csharp/custom/sensitive-data-log
 * @tags security
 *       external/cwe/cwe-532
 */

import csharp

/**
 * Holds if the given string matches a pattern for sensitive data field names.
 * Uses more specific patterns to reduce false positives (e.g., excludes FileName, HostName).
 */
bindingset[fieldName]
predicate isSensitiveFieldName(string fieldName) {
  // Convert to lowercase for case-insensitive matching
  exists(string lower | lower = fieldName.toLowerCase() |
    // Exact matches or specific patterns for sensitive fields
    lower.regexpMatch("(full)?name") or
    lower.regexpMatch("(sur|last|first)name") or
    lower.regexpMatch(".*email.*") or
    lower.regexpMatch(".*password.*") or
    lower.regexpMatch(".*(phone|mobile|telephone)(no|number)?") or
    lower.regexpMatch("(login|user)name")
  )
}

/**
 * Holds if the expression is a sensitive data access (property, field, or variable).
 */
predicate isSensitiveAccess(Expr e) {
  isSensitiveFieldName(e.(PropertyAccess).getTarget().getName()) or
  isSensitiveFieldName(e.(FieldAccess).getTarget().getName()) or
  isSensitiveFieldName(e.(VariableAccess).getTarget().getName())
}

/**
 * A call to a logging method from ILogger or similar logging frameworks.
 */
class LoggingMethodCall extends MethodCall {
  LoggingMethodCall() {
    exists(Method m | m = this.getTarget() |
      // Match methods named Log, LogInformation, LogWarning, LogError, LogDebug, LogTrace, LogCritical
      m.getName().regexpMatch("Log(Information|Warning|Error|Debug|Trace|Critical)?") and
      (
        // Methods on types containing "Logger" in the name
        m.getDeclaringType().getName().matches("%Logger%")
      )
    )
  }
}

from LoggingMethodCall logCall, Expr arg
where
  arg = logCall.getAnArgument() and
  (
    // Direct sensitive data access
    isSensitiveAccess(arg) or
    // String interpolation containing sensitive data access
    exists(InterpolatedStringExpr interpolated, Expr insert |
      arg = interpolated and
      insert = interpolated.getAnInsert() and
      isSensitiveAccess(insert)
    ) or
    // String concatenation containing sensitive data access
    exists(AddExpr add, Expr operand |
      arg = add and
      operand = add.getAnOperand() and
      isSensitiveAccess(operand)
    ) or
    // String.Format calls with sensitive arguments
    exists(MethodCall formatCall, Expr formatArg |
      arg = formatCall and
      formatCall.getTarget().hasName("Format") and
      formatCall.getTarget().getDeclaringType().getName() = "String" and
      formatCall.getTarget().getDeclaringType().getNamespace().getName() = "System" and
      formatArg = formatCall.getAnArgument() and
      isSensitiveAccess(formatArg)
    )
  )
select logCall, "Logging call may expose sensitive data"
