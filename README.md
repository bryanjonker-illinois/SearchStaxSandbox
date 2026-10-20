# SearchStaxSandbox

A tool to loop through an API to get data and store it in the SearchStax application. 

This requires a User Secret file that contains two strings:
* `ApiKey`: The API key for the SearchStax application.
* `Url`: The URL for the SearchStax application, including the update endpoint (`/update`).

Both of these can be retrieved from the https://searchstudio.searchstax.com/ URL or obtained from StratCom. 

Standard format:
```
{
  "Url": "https://xxxxxxxxxxxxxxxxxxxxxxxx",
  "ApiKey": "xxxxxxxxxxxxxxxxxxxxxxxx"
}
```

This will go through a JSON file that contains an array of objects, each with a `data` property. The tool will send each `data` object to the SearchStax application using the provided API key and URL, doing a transformation of the data. 

Each data object needs a custom transformation.

## PowerShell Components

We have PowerShell scripts that:
* **searchstax.ps1**: Mimics the console application to pull data from a source and generate people entries
* **searchstax_delete.ps1**: Sends a delete command to remove a page from the search stax list. 
* **searchstax_search.ps1**: Checks to see if a page is loaded.
* **searchstax_update.ps1**: Load a content item -- must include the page title, the page content, and the page URL. There is an optional category.

The search requires the read or read/write API key. All the others require the read/write API key.
