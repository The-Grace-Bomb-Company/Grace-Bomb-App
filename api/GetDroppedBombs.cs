using System.Globalization;
using System.Net;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Google.Apis.Sheets.v4;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace azure_functions
{
    public class GetDroppedBombs
    {
        private readonly ILogger _logger;

        public GetDroppedBombs(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<GetDroppedBombs>();
        }

        [Function("GetDroppedBombs")]
        public async Task<HttpResponseData> RunAsync([HttpTrigger(AuthorizationLevel.Function, "get")] HttpRequestData request)
        {
            var applicationName = "Grace Bomb App Test";

            var credential = GoogleCredential.FromJson(Configuration.GoogleCredential);

            var service = new SheetsService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = applicationName,
            });

            // Define request parameters.
            var googleSheetData = await service.Spreadsheets.Values.Get(Configuration.GoogleSpreadsheetId, Configuration.GoogleSpreadsheetRange).ExecuteAsync();

            var responseData = googleSheetData.Values.Aggregate(Enumerable.Empty<DroppedBomb>(), (droppedBombs, row) =>
            {
                try
                {
                    return droppedBombs.Append(new DroppedBomb
                    {
                        CreatedDate = DateTime.Parse(row[0].ToString()!, provider: default, DateTimeStyles.AssumeUniversal),
                        LocationName = row[1].ToString()!,
                        Latitude = double.Parse(row[2].ToString()!),
                        Longitude = double.Parse(row[3].ToString()!),
                        Description = row[4].ToString()!,
                        Id = Guid.Parse(row[5].ToString()!),
                        Title = row[6].ToString()!,
                        IsApproved = row[7].ToString()! == "1"
                    });
                }
                catch (Exception e)
                {
                    var rowString = string.Join(", ", row.Select(c => c.ToString()));
                    _logger.LogError(e, "Unable to parse row: {row}", rowString);
                    return droppedBombs;
                }
            });

            var httpResponse = request.CreateResponse(HttpStatusCode.OK);

            await httpResponse.WriteAsJsonAsync(responseData);

            return httpResponse;
        }
    }

    public class DroppedBomb
    {
        public Guid Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string LocationName { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public bool IsApproved { get; set; }
    }
}
