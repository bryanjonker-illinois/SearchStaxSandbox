using System.Dynamic;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;

namespace SearchStaxSandbox {
    internal class SearchStaxObject {
        private readonly JsonSerializerOptions _serializer = new() { PropertyNamingPolicy = new JsonNamingPolicyLowerCase() };
        public bool IsValid { get; set; } = true;
        public string Title { get; set; } = "";
        public string Title_txt_en { get; set; } = "";
        public string Description { get; set; } = "";
        public string Url { get; set; } = "";
        public string Url_t { get; set; } = "";
        public string Id { get; set; } = "";

        public string Content { get; set; } = "";
        private static readonly HttpClient client = new();
        public static async Task<SearchStaxObject> Generate(string source, string netId) {
            var url = $"https://directoryapi.wigg.illinois.edu/api/Directory/GetProfile/{source}/{netId}";
            try {
                var result = await client.GetFromJsonAsync<dynamic>(url);
                dynamic d = JsonSerializer.Deserialize<ExpandoObject>(result);
                var content = new StringBuilder();
                content.Append($"{d.fullName}");
                content.Append($" {d.primaryTitle}");
                content.Append($" {d.primaryOffice}");
                content.Append($" {d.roomNumber} {d.building}");
                content.Append($" {d.addressLine1} {d.addressLine2}");
                content.Append($" {d.biography}");
                content.Append($" {d.researchStatement}");
                content.Append($" {d.teachingStatement}");
                var description = $"{d.fullName} ({d.email}): {d.primaryTitle}, {d.primaryOffice}";
                var title = $"{d.fullName} | Illinois";
                var profileUrl = $"{d?.profileUrl}" ?? "";
                return new SearchStaxObject {
                    IsValid = true,
                    Title = title,
                    Title_txt_en = title,
                    Description = description,
                    Url = profileUrl,
                    Url_t = profileUrl,
                    Id = profileUrl,
                    Content = content.ToString()
                };

            } catch (Exception e) {
                return new SearchStaxObject { IsValid = false, Title = e.Message };
            }
        }
        public override string ToString() {
            return "{ \"add\": { \"doc\": " + JsonSerializer.Serialize(this, _serializer) + " } }";
        }
    }
}
