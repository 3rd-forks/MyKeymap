import os
import json
from flask import jsonify
from flask import request
from flask import Flask
from ahk_script import AhkScript

from flask_cors import CORS

app = Flask(__name__)
CORS(app)
app.config['JSON_SORT_KEYS'] = False
script = AhkScript()


@app.route('/', methods=['GET'])
def index_page():
    return '这不是主页'


@app.route('/config', methods=['GET'])
def get_config():
    with open('config.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
        return jsonify(data)

@app.route('/config', methods=['PUT'])
def save_config():
    data = request.get_json()
    with open('config.json', 'r+', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
        f.truncate()
    script.makeCapslock(data)
    return 'save config ok!'

if __name__ == '__main__':
    app.run(port=8000, debug=True)