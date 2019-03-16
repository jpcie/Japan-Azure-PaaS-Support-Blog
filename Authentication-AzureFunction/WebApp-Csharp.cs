/* Azure AD �e�i���g�̐ݒ� */
// Azure AD �e�i���g�̃f�B���N�g�� ID
string adId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
 
// �g�[�N�����s��
string authority = "https://login.microsoftonline.com/" + adId;
 
 
/* Function App �ō쐬���� AD �A�v�� */
// �N���C�A���g ID
string resourceApplicationId = "11f15836-8e45-4fb9-b9f8-b66611b21f8b";
 
 
/* �N���C�A���g�p�ɍ쐬���� AD �A�v�� */
// �A�v���P�[�V���� ID
string clientApplicationId = "3cd3551e-fc68-4510-b236-64c207b353fb";
 
// �V�[�N���b�g �L�[
string secretKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
 
 
/* �g�[�N������ */
// ADAL �� AuthenticationContext �I�u�W�F�N�g
AuthenticationContext authContext = new AuthenticationContext(authority);
 
// �N���C�A���g���i���
var clientCredential = new ClientCredential(clientApplicationId, secretKey);
 
// �g�[�N���v��
var authResult = authContext.AcquireTokenAsync(resourceApplicationId, clientCredential);
 
// Bearer �g�[�N��
string bearerToken = authResult.Result.CreateAuthorizationHeader();
 
 
/* Function �̌Ăяo�� */
// Function �� URL
string functionUri = "https://jpcieauthtest.azurewebsites.net/api/HttpTriggerCSharp1?code=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
 
// �v�� Body
string bodydata = "{\"name\": \"Azure\"}";
 
// Function �� HTTP �v���𑗐M
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