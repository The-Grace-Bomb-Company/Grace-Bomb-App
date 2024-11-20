using System.Globalization;
using System.Net;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Google.Apis.Sheets.v4;
using Google.Apis.Sheets.v4.Data;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace azure_functions
{
    public class SaveNewBomb
    {
        private readonly ILogger _logger;

        public SaveNewBomb(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<SaveNewBomb>();
        }

        [Function("SaveNewBomb")]
        public async Task<HttpResponseData> RunAsync([HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData request)
        {
            _logger.LogInformation("SaveNewBomb function triggered.");

            // Parse the request body
            var requestBody = await request.ReadAsStringAsync();
            BombData? bombData;
            try
            {
                bombData = JsonConvert.DeserializeObject<BombData>(requestBody);
                if (bombData == null || string.IsNullOrEmpty(bombData.Title) || string.IsNullOrEmpty(bombData.Description))
                {
                    throw new Exception("Invalid payload: Title and Description are required.");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Invalid request payload.");
                var badRequestResponse = request.CreateResponse(HttpStatusCode.BadRequest);
                await badRequestResponse.WriteStringAsync("Invalid request payload.");
                return badRequestResponse;
            }

            // Authenticate with Google Sheets API
            var applicationName = "Grace Bomb App Test";
            var credential = GoogleCredential.FromJson(Configuration.GoogleCredential);

            var service = new SheetsService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = applicationName,
            });

            // Prepare data to append
            var newRow = new List<object>
            {
                DateTime.UtcNow.ToString("o"),    // Created Date in ISO 8601 format
                bombData.Title,                  // Bomb Title
                bombData.Description,            // Bomb Description
                bombData.Latitude.ToString(CultureInfo.InvariantCulture), // Latitude
                bombData.Longitude.ToString(CultureInfo.InvariantCulture), // Longitude
                Guid.NewGuid().ToString(),       // Unique ID
            };

            // Append the new row to the Google Sheet
            try
            {
                var appendRequest = service.Spreadsheets.Values.Append(
                    new ValueRange { Values = new List<IList<object>> { newRow } },
                    Configuration.GoogleSpreadsheetId,
                    Configuration.GoogleSpreadsheetRange
                );
                appendRequest.ValueInputOption = SpreadsheetsResource.ValuesResource.AppendRequest.ValueInputOptionEnum.USERENTERED;

                await appendRequest.ExecuteAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to append data to Google Sheets.");
                var internalErrorResponse = request.CreateResponse(HttpStatusCode.InternalServerError);
                await internalErrorResponse.WriteStringAsync("Failed to save bomb data.");
                return internalErrorResponse;
            }

            // Return success response
            var response = request.CreateResponse(HttpStatusCode.OK);
            await response.WriteStringAsync("Bomb data saved successfully.");
            return response;
        }
    }

    public class BombData
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}