# Logging of Sensitive Data

## Description

This query detects when sensitive data (such as names, surnames, email addresses, passwords, or phone numbers) is being logged using logging frameworks like Microsoft.Extensions.Logging. Logging sensitive data can lead to security vulnerabilities if log files are exposed or accessed by unauthorized parties.

Sensitive information in logs can be exploited by attackers who gain access to log files through various means, including:
- Misconfigured log storage or permissions
- Log aggregation services
- Backup systems
- Development or staging environments
- Third-party log analysis tools

## Recommendation

To prevent sensitive data from being logged:

- **Never log passwords or authentication tokens** - These should never appear in logs under any circumstances.
- **Avoid logging personally identifiable information (PII)** - Names, email addresses, phone numbers, and similar data should not be logged.
- **Use data masking or redaction** - If you must log sensitive data for debugging purposes, mask or redact it (e.g., "user@*****.com" or "***-***-1234").
- **Log identifiers instead of sensitive data** - Use non-sensitive identifiers like user IDs or transaction IDs instead of personal information.
- **Implement structured logging** - Use structured logging to control what fields are logged and apply filtering or masking policies.
- **Review logging configurations** - Ensure log levels and outputs are appropriate for production environments.
- **Secure log storage** - Implement proper access controls and encryption for log files.

## Example

```csharp
using Microsoft.Extensions.Logging;

public class EmployeeService
{
    private readonly ILogger<EmployeeService> logger;

    public EmployeeService(ILogger<EmployeeService> logger)
    {
        this.logger = logger;
    }

    // BAD: Logging sensitive employee data
    public void BadLoggingExample(Employee employee)
    {
        // Vulnerable - logs sensitive personal information
        logger.LogInformation($"Employee name: {employee.Name}");
        logger.LogInformation($"Employee email: {employee.Email}");
        logger.LogWarning($"Failed login for user: {employee.LoginName}");
        logger.LogError($"Password reset failed for: {employee.Password}");
        logger.LogDebug($"Contact phone: {employee.PhoneNo}");
    }

    // GOOD: Logging without sensitive data
    public void GoodLoggingExample(Employee employee)
    {
        // Safe - uses non-sensitive identifiers
        logger.LogInformation($"Employee ID: {employee.Id}");
        logger.LogInformation($"Department: {employee.Department}");
        logger.LogWarning($"Failed login for user ID: {employee.Id}");
        logger.LogError($"Password reset failed for user ID: {employee.Id}");
        
        // Safe - uses masked data if absolutely necessary
        logger.LogDebug($"Contact phone: ***-***-{employee.PhoneNo.Substring(employee.PhoneNo.Length - 4)}");
    }

    // GOOD: Using structured logging with filtering
    public void StructuredLoggingExample(Employee employee)
    {
        // Safe - structured logging allows for field-level filtering
        logger.LogInformation("Employee action completed for {EmployeeId} in {Department}", 
            employee.Id, employee.Department);
    }
}
```

## References

- [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html)
- [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
- [Microsoft Logging and diagnostics](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/)
- [OWASP Top 10 2021 - A09:2021 Security Logging and Monitoring Failures](https://owasp.org/Top10/A09_2021-Security_Logging_and_Monitoring_Failures/)
