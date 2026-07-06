using Microsoft.Extensions.Configuration;
using SearchStaxSandbox;

var config = new ConfigurationBuilder().AddUserSecrets<Program>().Build();

var helper = new SearchStaxHelper(config["ApiKey"], config["Url"]);

var source = "education";

var directoryList = await DirectoryList.Generate(source);
var errorList = new List<string>();

var newName = new List<string> {
    "anmeyer2",
    "as227"
};


foreach (var name in directoryList.NetIds) {
    Console.WriteLine("NetID: " + name);
    var searchStaxJson = await SearchStaxObject.Generate(source, name);
    Console.WriteLine("Profile Url: " + searchStaxJson.Id);
    if (searchStaxJson.Id == "" || !searchStaxJson.IsValid) {
        errorList.Add(name);
    } else {
        var result = await helper.Send(searchStaxJson.ToString());
        Console.WriteLine(result);
    }
}

Console.WriteLine("errors");
foreach (var name in errorList) {
    Console.WriteLine(name);
}
