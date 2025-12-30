/**
 * @name Usage of @SuppressWarnings annotation
 * @description Detects when developers are adding the Java annotation "@SuppressWarnings"
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/custom/suppress-warnings-usage
 * @tags code-quality
 *       maintainability
 */

import java

from Annotation annotation
where annotation.getType().hasName("SuppressWarnings")
select annotation, "Usage of @SuppressWarnings annotation detected"
