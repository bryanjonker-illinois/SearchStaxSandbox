using System.Dynamic;
using System.Net.Http.Json;
using System.Text.Json;

namespace SearchStaxSandbox {
    internal class DirectoryList {
        private readonly JsonSerializerOptions _serializer = new() { PropertyNamingPolicy = new JsonNamingPolicyLowerCase() };

        public List<string> NetIds { get; set; } = new List<string>();

        public string Error { get; set; } = "";

        private static readonly HttpClient client = new();

        public static async Task<DirectoryList> Generate(string source) {
            var url = $"https://directoryapi.wigg.illinois.edu/api/Directory/Search/{source}?take=999";
            var returnValue = new DirectoryList();
            try {
                returnValue.NetIds = new List<string>();
                var result = await client.GetFromJsonAsync<dynamic>(url);
                dynamic d = JsonSerializer.Deserialize<ExpandoObject>(result);
                foreach (var person in d.people.EnumerateArray()) {
                    returnValue.NetIds.Add(((dynamic)person).GetProperty("netId").GetString());
                }
                returnValue.NetIds = [.. returnValue.NetIds.OrderBy(x => x)];
            } catch (Exception e) {
                returnValue.Error = e.Message;
            }
            return returnValue;
        }
    }
}
