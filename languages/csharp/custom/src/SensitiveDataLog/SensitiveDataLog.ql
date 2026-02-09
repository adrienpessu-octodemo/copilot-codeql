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
    // Direct property access with sensitive name
    arg.(PropertyAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
    // Field access with sensitive name
    arg.(FieldAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
    // Variable access with sensitive name
    arg.(VariableAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
    // String interpolation containing sensitive property/field/variable access
    exists(InterpolatedStringExpr interpolated, Expr insert |
      arg = interpolated and
      insert = interpolated.getAnInsert() and
      (
        insert.(PropertyAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        insert.(FieldAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        insert.(VariableAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*")
      )
    ) or
    // String concatenation containing sensitive property/field/variable access
    exists(AddExpr add, Expr operand |
      arg = add and
      operand = add.getAnOperand() and
      (
        operand.(PropertyAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        operand.(FieldAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        operand.(VariableAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*")
      )
    ) or
    // String.Format calls with sensitive arguments
    exists(MethodCall formatCall, Expr formatArg |
      arg = formatCall and
      formatCall.getTarget().hasName("Format") and
      formatCall.getTarget().getDeclaringType().getName() = "String" and
      formatCall.getTarget().getDeclaringType().getNamespace().getName() = "System" and
      formatArg = formatCall.getAnArgument() and
      (
        formatArg.(PropertyAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        formatArg.(FieldAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*") or
        formatArg.(VariableAccess).getTarget().getName().regexpMatch("(?i).*(name|surname|lastname|firstname|email|password|phone|mobile|telephone|loginname).*")
      )
    )
  )
select logCall, "Logging call may expose sensitive data"
