#!/usr/bin/env python3

import os
import json
from flask import jsonify
from flask import request
from flask import Flask
from flask import render_template
from ahk_script import AhkScript
from flask_cors import CORS
import sys

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

def serveApi():
    import logging
    log = logging.getLogger('werkzeug')
    log.setLevel(logging.ERROR)
    # os.system('chcp 65001')
    # os.system('cls')
    print()
    print('   ------------------------------------------------------------------')
    print('   1. 打开浏览器访问 http://localhost:12333 修改 MyKeyamp 的配置')
    print('   2. 保存配置后需要按 alt+\' 重启 MyKeymap (这里的\'是单引号键) ')
    print('   3. 修改完 MyKeymap 的配置后即可关闭本窗口')
    print('   ------------------------------------------------------------------')
    os.environ['WERKZEUG_RUN_MAIN'] = 'true'    # 关掉 flask 启动消息
    app.run(port=12333, debug=False)

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print('必须提供一个参数,  rain 或 api')
        exit(1)
    arg = sys.argv[1]
    if (arg == '--server'):
        serveApi()
    elif (arg == '--rain'):
        from unimatrix import startRain
        startRain()