/**
 * @name Detect @antv/data-set in package-lock.json
 * @description Detects @antv/data-set dependencies in npm package-lock.json and reports the version.
 * @kind problem
 * @problem.severity error
 * @security-severity 10.0
 * @precision high
 * @id javascript/custom/detect-antv-data-set
 * @tags security
 *       external/cwe/cwe-1104
 */

import javascript

class PackageLockJson extends JsonObject {
  PackageLockJson() {
    this.isTopLevel() and
    this.getJsonFile().getBaseName() = "package-lock.json"
  }
}

private JsonString antvDependencyValue(PackageLockJson lockFile) {
  result =
    lockFile
        .getPropValue("packages")
        .getPropValue("")
        .getPropValue("dependencies")
        .getPropValue("@antv/data-set")
  or
  result =
    lockFile
        .getPropValue("dependencies")
        .getPropValue("@antv/data-set")
        .getPropValue("version")
  or
  result =
    lockFile
        .getPropValue("packages")
        .getPropValue("node_modules/@antv/data-set")
        .getPropValue("version")
}

from PackageLockJson lockFile, JsonString dependency, string version
where
  dependency = antvDependencyValue(lockFile) and
  version = dependency.getStringValue()
select dependency,
  "Detected @antv/data-set dependency with version " + version + "."
