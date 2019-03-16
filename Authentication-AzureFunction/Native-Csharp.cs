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
string clientApplicationId = "dbcb7ba3-c667-4323-a310-a5e834b32675";
 
// ���_�C���N�g URI
string redirectUri = "https://jpciesample/MyNativeApp";
 
 
/* �g�[�N������ */
// ADAL �� AuthenticationContext �I�u�W�F�N�g
AuthenticationContext authContext = new AuthenticationContext(authority);
 
// �g�[�N���v�� (���i��񂪃L���b�V������Ă��Ȃ��ꍇ�A���i���v�����v�g���N�����܂�)
var authResult = authContext.AcquireTokenAsync(resourceApplicationId, clientApplicationId, new Uri(redirectUri), new PlatformParameters(PromptBehavior.Auto, null));
 
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