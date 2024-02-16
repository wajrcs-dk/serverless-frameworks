import os

from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/')
def fibonacci():
    req = request.args.get('x')
    nterms = int(req)
    n1, n2 = 0, 1
    count = 0
    result = []

    while count < nterms:
        result.append(n1)
        nth = n1 + n2
        # update values
        n1 = n2
        n2 = nth
        count += 1
        
    return {"result": result}

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
