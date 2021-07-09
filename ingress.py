from flask import Flask, current_app
import tablib

app = Flask (__name__)

dataset = tablib.Dataset()
with open('results.csv') as f:
    dataset.csv = f.read()


@app.route("/")
def index():
    return current_app.response_class(dataset.json, mimetype="application/json")


if __name__ == "__main__":
    app.run(host='0.0.0.0',port='8080', debug=True)
