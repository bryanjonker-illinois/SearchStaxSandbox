using System.Text;

namespace SearchStaxSandbox {
    internal class SearchStaxHelper {
        public SearchStaxHelper(string apiToken, string url) {
            this.apiToken = apiToken ?? "";
            this.url = url ?? "";
        }
        private string apiToken;
        private string url;

        public async Task<string> Send(string s) {
            using var client = new HttpClient();
            using var requestMessage = new HttpRequestMessage(HttpMethod.Post, url + "?commit=true");
            requestMessage.Content = new StringContent(s, Encoding.UTF8, "application/json");
            requestMessage.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Token", apiToken);
            var response = await client.SendAsync(requestMessage);
            var returnValue = await response.Content?.ReadAsStringAsync();
            return returnValue;
        }
    }
}
