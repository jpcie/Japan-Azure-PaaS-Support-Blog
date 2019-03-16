/* Azure AD テナントの設定 */
// Azure AD テナントのディレクトリ ID
string adId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
 
// トークン発行元
string authority = "https://login.microsoftonline.com/" + adId;
 
 
/* Function App で作成した AD アプリ */
// クライアント ID
string resourceApplicationId = "11f15836-8e45-4fb9-b9f8-b66611b21f8b";
 
 
/* クライアント用に作成した AD アプリ */
// アプリケーション ID
string clientApplicationId = "3cd3551e-fc68-4510-b236-64c207b353fb";
 
// シークレット キー
string secretKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
 
 
/* トークン生成 */
// ADAL の AuthenticationContext オブジェクト
AuthenticationContext authContext = new AuthenticationContext(authority);
 
// クライアント資格情報
var clientCredential = new ClientCredential(clientApplicationId, secretKey);
 
// トークン要求
var authResult = authContext.AcquireTokenAsync(resourceApplicationId, clientCredential);
 
// Bearer トークン
string bearerToken = authResult.Result.CreateAuthorizationHeader();
 
 
/* Function の呼び出し */
// Function の URL
string functionUri = "https://jpcieauthtest.azurewebsites.net/api/HttpTriggerCSharp1?code=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
 
// 要求 Body
string bodydata = "{\"name\": \"Azure\"}";
 
// Function に HTTP 要求を送信
HttpWebRequest request = WebRequest.Create(functionUri) as HttpWebRequest;
request.Method = "POST";
request.Headers["Authorization"] = bearerToken;
request.ContentType = "application/json";
 
Stream reqstr = request.GetRequestStream();
reqstr.Write(Encoding.ASCII.GetBytes(bodydata), 0, bodydata.Length);
reqstr.Close();
 
HttpWebResponse response = request.GetResponse() as HttpWebResponse;
Stream resstr = response.GetResponseStream();
StreamReader sr = new StreamReader(resstr);
string resresult = sr.ReadToEnd();
 
Console.WriteLine(resresult);