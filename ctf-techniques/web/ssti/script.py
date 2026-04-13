# Example Flask application to expose an "execute" endpoint to run any command on the server
from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_command():
    command = request.json.get('command')  # Get command from the JSON body
    try:
        # Use subprocess to run the command
        output = subprocess.check_output(command, shell=True, stderr=subprocess.
STDOUT, text=True)
        return jsonify({'output': output}), 200
    except subprocess.CalledProcessError as e:
        return jsonify({'error': str(e), 'output': e.output}), 400

if __name__ == '__main__':
    app.run(host='10.102.151.24', port=5000)

