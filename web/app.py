import logging
from typing import List, Dict
from flask import Flask
import mysql.connector
import json
import os

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

def favorite_colors() -> List[Dict]:
    config = {
        'user': os.environ['DB_USER_NAME'],
        'password': os.environ['DB_USER_PASSWORD'],
        'host': os.environ['DB_HOST'],
        'port': '3306',
        'database': os.environ['DB_DATABASE']
    }
    connection = mysql.connector.connect(**config)
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM favorite_colors')
    results = [{name: color} for (name, color) in cursor]
    cursor.close()
    connection.close()

    return results


@app.route('/')
def index() -> str:
    app.logger.info('change!')
    return json.dumps({'favorite_colors': favorite_colors()})


if __name__ == '__main__':
    app.run(host='0.0.0.0')
