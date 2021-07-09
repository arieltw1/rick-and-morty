from flask import Flask, jsonify
import tablib
import os

app = Flask (__name__)
#app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True

#fun var

dataset = tablib.Dataset()
with open('results.csv') as f:
    dataset.csv = f.read()


@app.route("/")
def index():
    return jsonify(dataset.json)


if __name__ == "__main__":
    app.run(host='0.0.0.0',port='8080', debug=True)
