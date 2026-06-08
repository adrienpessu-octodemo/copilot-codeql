using System;

// Mock Microsoft.Extensions.Logging for testing purposes
namespace Microsoft.Extensions.Logging
{
    public enum LogLevel
    {
        Trace = 0,
        Debug = 1,
        Information = 2,
        Warning = 3,
        Error = 4,
        Critical = 5,
        None = 6
    }

    public interface ILogger
    {
        void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter);
    }

    public struct EventId
    {
        public EventId(int id, string name = null)
        {
            Id = id;
            Name = name;
        }

        public int Id { get; }
        public string Name { get; }
    }

    public static class LoggerExtensions
    {
        public static void LogInformation(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Information, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogInformation(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Information, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogWarning(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Warning, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogWarning(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Warning, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogError(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Error, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogError(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Error, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogDebug(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Debug, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogDebug(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Debug, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogTrace(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Trace, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogTrace(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Trace, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogCritical(this ILogger logger, string message)
        {
            logger.Log(LogLevel.Critical, default(EventId), message, null, (state, ex) => state);
        }

        public static void LogCritical(this ILogger logger, string message, params object[] args)
        {
            logger.Log(LogLevel.Critical, default(EventId), message, null, (state, ex) => state);
        }
    }
}

namespace SensitiveDataLogTest
{
    using Microsoft.Extensions.Logging;

    // Model class with sensitive and non-sensitive properties
    public class EmployeeDataModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PhoneNo { get; set; }
        public string MobileNumber { get; set; }
        public string Telephone { get; set; }
        public string LoginName { get; set; }
        public string Domain { get; set; }
        public string BranchCode { get; set; }
        public string Department { get; set; }
    }

    // Model class to test false positive avoidance
    public class ConfigurationDataModel
    {
        public string FileName { get; set; }
        public string HostName { get; set; }
        public string DomainName { get; set; }
        public string ServerName { get; set; }
        public string DisplayName { get; set; }
        public int Timeout { get; set; }
    }

    public class LoggingTestClass
    {
        private readonly ILogger logger;

        public LoggingTestClass(ILogger logger)
        {
            this.logger = logger;
        }

        // VULNERABLE: Direct logging of sensitive properties
        public void VulnerableDirectLogging(EmployeeDataModel employee)
        {
            // Should be detected - logging sensitive property directly
            logger.LogInformation(employee.Name);
            logger.LogInformation(employee.Surname);
            logger.LogError(employee.Email);
            logger.LogWarning(employee.Password);
            logger.LogDebug(employee.PhoneNo);
            logger.LogTrace(employee.MobileNumber);
            logger.LogCritical(employee.Telephone);
            logger.LogInformation(employee.LoginName);
            logger.LogInformation(employee.FirstName);
            logger.LogError(employee.LastName);
        }

        // VULNERABLE: String interpolation with sensitive data
        public void VulnerableStringInterpolation(EmployeeDataModel employee)
        {
            // Should be detected - string interpolation with sensitive properties
            logger.LogInformation($"Employee name: {employee.Name}");
            logger.LogInformation($"User email: {employee.Email}");
            logger.LogWarning($"Password: {employee.Password}");
            logger.LogError($"Contact phone: {employee.PhoneNo}");
        }

        // VULNERABLE: String concatenation with sensitive data
        public void VulnerableStringConcatenation(EmployeeDataModel employee)
        {
            // Should be detected - string concatenation with sensitive properties
            logger.LogInformation("Employee: " + employee.Name);
            logger.LogInformation("Email: " + employee.Email);
            logger.LogError("User: " + employee.LoginName);
        }

        // VULNERABLE: Using string.Format with sensitive data
        public void VulnerableStringFormat(EmployeeDataModel employee)
        {
            // Should be detected - string.Format with sensitive properties
            logger.LogInformation(string.Format("Name: {0}", employee.Name));
            logger.LogError(string.Format("Email: {0}, Phone: {1}", employee.Email, employee.PhoneNo));
        }

        // VULNERABLE: Logging with parameters containing sensitive data
        public void VulnerableParameterizedLogging(EmployeeDataModel employee)
        {
            // Should be detected - parameterized logging with sensitive data
            logger.LogInformation("Employee name: {Name}", employee.Name);
            logger.LogInformation("User email: {Email}", employee.Email);
            logger.LogError("Password: {Password}", employee.Password);
        }

        // VULNERABLE: Logging sensitive local variables
        public void VulnerableSensitiveVariables()
        {
            string userName = "FAKE_USER";
            string userPassword = "FAKE_PASSWORD";
            string userEmail = "fake@example.test";
            string phoneNumber = "000-0000";

            // Should be detected - logging sensitive variables
            logger.LogInformation(userName);
            logger.LogError(userPassword);
            logger.LogWarning(userEmail);
            logger.LogDebug(phoneNumber);
        }

        // SAFE: Logging non-sensitive properties
        public void SafeNonSensitiveLogging(EmployeeDataModel employee)
        {
            // Should NOT be detected - logging non-sensitive properties
            logger.LogInformation($"Employee ID: {employee.Id}");
            logger.LogInformation($"Department: {employee.Department}");
            logger.LogInformation($"Branch: {employee.BranchCode}");
            logger.LogInformation($"Domain: {employee.Domain}");
        }

        // SAFE: Logging non-sensitive variables
        public void SafeVariableLogging()
        {
            string status = "Active";
            string department = "Engineering";
            int employeeId = 12345;

            // Should NOT be detected - logging non-sensitive variables
            logger.LogInformation(status);
            logger.LogInformation(department);
            logger.LogInformation(employeeId.ToString());
        }

        // SAFE: Logging constants and literals
        public void SafeLiteralLogging()
        {
            // Should NOT be detected - logging literal strings
            logger.LogInformation("Application started");
            logger.LogError("An error occurred");
            logger.LogWarning("Warning message");
        }

        // SAFE: Logging non-sensitive properties that contain "name" but aren't PII
        public void SafeNonSensitiveNameFields(ConfigurationDataModel config)
        {
            // Should NOT be detected - these are configuration fields, not PII
            logger.LogInformation($"Config file: {config.FileName}");
            logger.LogInformation($"Host: {config.HostName}");
            logger.LogInformation($"Domain: {config.DomainName}");
            logger.LogInformation($"Server: {config.ServerName}");
            logger.LogInformation($"Display: {config.DisplayName}");
        }
    }
}
