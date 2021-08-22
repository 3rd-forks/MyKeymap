import os
import json
from flask import jsonify
from flask import request
from flask import Flask
from flask import render_template
from ahk_script import AhkScript

from flask_cors import CORS

app = Flask(__name__, static_url_path='', static_folder='site',)
CORS(app)
app.config['JSON_SORT_KEYS'] = False
script = AhkScript()


@app.route('/', methods=['GET'])
def index_page():
    return render_template('index.html')


@app.route('/config', methods=['GET'])
def get_config():
    with open('../data/config.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
        return jsonify(data)

@app.route('/config', methods=['PUT'])
def save_config():
    data = request.get_json()
    with open('../data/config.json', 'r+', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
        f.truncate()
    script.makeCapslock(data)
    return 'save config ok!'

if __name__ == '__main__':
    import logging
    os.system('chcp 65001')
    os.system('cls')
    log = logging.getLogger('werkzeug')
    log.setLevel(logging.ERROR)
    print()
    print(' ------------------------------------------------------------------')
    print(' 1. 浏览器访问 http://localhost:12333 修改 MyKeyamp 的配置')
    print(' 2. 修改并保存配置后按 alt+\' 可重启 MyKeymap (这里的\'是单引号键) ')
    print(' 3. 修改完 MyKeymap 的配置后即可关闭本窗口')
    print(' ------------------------------------------------------------------')
    app.run(port=12333, debug=True)