#The main Flask application logic handles the form submission, builds the JSON payload, executes the system `curl` command, and renders the result.
from flask import Flask, render_template, request
import subprocess
import json

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    selected_datasets = request.form.getlist('datasets')
    app.logger.info("Received dataset submission: %s", selected_datasets)

    # Target URL (Using httpbin.org as a public testing endpoint for POST requests)
    target_url = "https://httpbin.org/post"
    results = []

    for dataset_value in selected_datasets:
        payload = json.dumps({"dataset": dataset_value})
        curl_cmd = [
            "curl", "-sS", "-X", "POST",
            "-H", "Content-Type: application/json",
            "-d", payload,
            target_url
        ]

        try:
            result = subprocess.run(curl_cmd, capture_output=True, text=True, check=True)
            response_output = result.stdout
            app.logger.info("curl request completed successfully for %s", dataset_value)
        except subprocess.CalledProcessError as e:
            response_output = f"Error executing curl command: {e.stderr}"
            app.logger.exception("curl request failed for %s: %s", dataset_value, e.stderr)

        results.append({"dataset": dataset_value, "response": response_output})

    return render_template(
        'result.html',
        datasets=selected_datasets,
        results=results
    )

if __name__ == '__main__':
    # Runs over HTTPS using the generated self-signed certificate and key
    app.run(host='0.0.0.0', port=5000, ssl_context=('cert.pem', 'key.pem'))