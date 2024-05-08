namespace azure_functions
{
    public static class Configuration {
        public static string? GoogleCredential = GetEnvVar("google_credential");
        public static string? GoogleSpreadsheetId = GetEnvVar("google_spreadsheet_id");

        private static string? GetEnvVar(string name) => Environment.GetEnvironmentVariable(name);
    }
}
