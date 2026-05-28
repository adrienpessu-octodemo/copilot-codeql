/**
 * @name jQuery usage
 * @description Detects usage of jQuery APIs.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id javascript/custom/jquery-usage
 * @tags security
 */

import javascript

from DataFlow::CallNode call
where call.getCalleeName() in ["$", "jQuery"]
select call.asExpr(), "jQuery usage detected."
