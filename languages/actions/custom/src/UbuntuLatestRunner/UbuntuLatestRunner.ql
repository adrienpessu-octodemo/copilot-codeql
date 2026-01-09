/**
 * @name Usage of ubuntu-latest runner
 * @description Detects when workflows use ubuntu-latest instead of a specific version
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id actions/custom/ubuntu-latest-runner
 * @tags code-quality
 *       maintainability
 *       actions
 */

import actions

from Job job
where job.getARunsOnLabel() = "ubuntu-latest"
select job,
  "Usage of ubuntu-latest in runs-on. Consider using a specific Ubuntu version for reproducibility."
