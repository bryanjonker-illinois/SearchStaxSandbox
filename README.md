# SearchStaxSandbox

A tool to loop through an API to get data and store it in the SearchStax application. 

This requires a User Secret file that contains two strings:
* `ApiKey`: The API key for the SearchStax application.
* `Url`: The URL for the SearchStax application, including the update endpoint (`/update`).

This will go through a JSON file that contains an array of objects, each with a `data` property. The tool will send each `data` object to the SearchStax application using the provided API key and URL, doing a transformation of the data. 

Each data object needs a custom transformation.