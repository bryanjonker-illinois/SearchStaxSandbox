using System.Text.Json;

namespace SearchStaxSandbox {
    public class JsonNamingPolicyLowerCase : JsonNamingPolicy {

        public override string ConvertName(string name) => name.ToLower();
    }
}
