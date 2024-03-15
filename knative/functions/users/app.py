import os

from flask import Flask
from flask import request
import mysql.connector
import json

app = Flask(__name__)

@app.route('/')
def users():
    mydb = mysql.connector.connect(
        host="mysql-read.default.svc.cluster.local",
        user="root",
        password="",
        database="dzhw",
        port="3306"
    )
    cur = mydb.cursor()
    cur.execute('''SELECT * FROM users''')
    row_headers=[x[0] for x in cur.description]
    rv = cur.fetchall()
    json_data=[]
    
    for result in rv:
        json_data.append(dict(zip(row_headers,result)))
    
    cur.close()
    return json.dumps(json_data, default = str)

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
