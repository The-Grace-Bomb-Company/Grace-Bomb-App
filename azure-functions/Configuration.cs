namespace azure_functions
{
    public static class Configuration {
        public static string? GoogleCredential = GetEnvVar("google_credential");

        public static string? GoogleSpreadsheetId = GetEnvVar("google_spreadsheet_id");

        public static string? GoogleSpreadsheetRange = GetEnvVar("google_spreadsheet_range");

        private static string? GetEnvVar(string name) => Environment.GetEnvironmentVariable(name);
    }
}
