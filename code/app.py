from flask import Flask, current_app
from healthcheck import HealthCheck
import tablib

app = Flask(__name__)
health = HealthCheck()
dataset = tablib.Dataset()


with open('results.csv') as f:
    dataset.csv = f.read()

@app.route("/")
def index():
    return current_app.response_class(dataset.json, mimetype="application/json")

app.add_url_rule("/healthcheck", "healthcheck", view_func=lambda: health.run())

if __name__ == "__main__":
    app.run(host='0.0.0.0',port='8080', debug=True)
