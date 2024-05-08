using System.Diagnostics;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Google.Apis.Sheets.v4;
using Google.Apis.Sheets.v4.Data;

var stopwatch = new Stopwatch();
stopwatch.Start();

var applicationName = "Grace Bomb App Test";

// var credential = await GoogleCredential.FromFileAsync("client-secret.json", default);

var credential = GoogleCredential.FromJson("""
{"type":"service_account","project_id":"grace-bomb-app","private_key_id":"95dd16bc13bd030c999cf9387e7040708cdfbb0b","private_key":"-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDUIuY7G5QSDpul\nYaHXPKU6LsUWNS9DmAnkW5pWbU2DQY0mvlE0i7Z9peAYDjXUVaNi/IIFjxB7AsxF\nRRpgh+UMDJncWdsUAiFL1Me8bcZBwpMPhdHuTlrv/fmxEkXrDaw5WWGhauMVyaDA\nLi6atcXEE0L/5HZoZhRN9Fb47riBBcNIM/EcKtwflba9ti+DB+jwvDnOsP5giv5w\nHPOwsXKdKPQqCq5HtOr+a9rQ/Tlwug+yT05JDKUvpnzNs23OCzKcj1YItRGJie8Z\ni+rYM8LgFuCUB646Fo2kvXa6fFdOXnKcTExOwQioAG0PRqvAdgaEpe2encl3AMRR\n861Yk8TbAgMBAAECggEAQn9EG1AsTLK+kIt3v3AXvRLPHgSC8dXVd/tM+H2f2B6y\nv+vVqbqH9IAMLI47ynkj09IicdqkSGMapDYirBK9Nlc23c9e8LkwNcSX7dWdWZzE\nG5APu/tc3zEGVb7MIv/wtjNx+rb2QyymkseHPWDwguOk03EKuvQQtlT69GJkfLC+\nowFYRn0+2n2Ykfab3IXiJzL5lXlwcC1YwLcueucWja4dOS95NHJXk4tI0sLHcU/B\nLHxDGIjKzEP/xgoer2RGvxvuR/hsEPORXYeizqJVYcAaUkYVnBCcWxID+hF1GTFp\nkVgBldtFCRnwbCKbzVE9rZ13ShJ3WnapIOsmht1SiQKBgQD9snwZ5dobGAVaXmt5\nYvACYOJGqX2FN3yD/nzRj5xwNXy9ve/wluC23JrVZVA5fm3fQ/vegbP2XR+Y8N2a\nWMFL0pmJr03Gy5GzeoloS7ePutnoQjJY1me7/gFfOyl/4BMuu+a2UNTNWtz2R45+\nod6SE3PzRGDccJjdlr63SftvswKBgQDWD9b3NXL5ke3lIov0f8MuC6WtVMc8J4H+\n+dQ7WZfvbEgEqQtXEPFc6c+Fb4TSYviGFl5CIQhAzN86azUoqzc4X/fDJDpzBM36\ni/M7/tKYHmwHiVmRmc/yzwlQc3Lgq0efiGzG6SH/XrjJxzOwFUa2JYDMGG69uPod\nlDfQxCWCOQKBgGZG75stPCnSHE5bZG6ygVokHvUn3W+4d91q2n1NrV7bYWfJTBMt\ncHioJU/EoXwcSUVKTh9dIOVAk71/1YclIwBjbfzBDNUJOrsluoGujNlIFhN5pHyG\nK5nxhDIVUty3xGQB4rg7jB8h85TiMkNBFM7FQuie94HHbwlefZK9I73bAoGBAMpr\nvhaUt32i7jgwO/Jf4pynLOtEcQbEQVxwuK3K4i7o0Q1/IRcbEXKQMsn2k74zEtoR\nSt7zx48nbKwcdu9XQOeRcIRavN7JG1KihsckB9cLZZKW4lkZ/xeXijJGicpEjX0h\nj+Nkz95hnxJHyevnoq9ZtXrKW+YShonz//ftk56ZAoGBALZi4OyRyH5UgwwaXgh7\nXP/Phi9oHpuc7KZiLfab78V67E45utVbwK6/AfN8PqnxzethrIhaTjnHY9dEHyqJ\nsLUShJn1L8SB5obExbM7wJ06JH88dCrlPD9hWvirYs4VLs+WBI/Zs1HS9Yj34XsH\nc68tNxrlfYISneajprF+bm/E\n-----END PRIVATE KEY-----\n","client_email":"grace-bomb-app@grace-bomb-app.iam.gserviceaccount.com","client_id":"114457328383339162160","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/grace-bomb-app%40grace-bomb-app.iam.gserviceaccount.com","universe_domain":"googleapis.com"}
""");

var service = new SheetsService(new BaseClientService.Initializer()
{
    HttpClientInitializer = credential,
    ApplicationName = applicationName,
});

// Define request parameters.
var spreadsheetId = "1CrShwKtsiXPvuwC6K_DRF63OYfR3p67SbVhGfqhadEo";
var range = "Grace Bomb App Data!A1:F";
SpreadsheetsResource.ValuesResource.GetRequest request =
    service.Spreadsheets.Values.Get(spreadsheetId, range);

ValueRange response = request.Execute();
stopwatch.Stop();
Console.WriteLine(stopwatch.ElapsedMilliseconds);
// foreach (var row in response.Values)
// {
//     var line = string.Join(", ", row);
//     Console.WriteLine(line);
// }