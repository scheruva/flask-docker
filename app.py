from flask import Flask, render_template, request
import subprocess
import json

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    dataset_value = request.form.get('dataset')
    payload = json.dumps({"dataset": dataset_value})
    target_url = "https://httpbin.org/post"
    
    curl_cmd = [
        "curl", "-s", "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", payload,
        target_url
    ]
    
    try:
        result = subprocess.run(curl_cmd, capture_output=True, text=True, check=True)
        response_output = result.stdout
    except subprocess.CalledProcessError as e:
        response_output = f"Error executing curl command: {e.stderr}"
    
    return render_template('result.html', dataset=dataset_value, response=response_output)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
