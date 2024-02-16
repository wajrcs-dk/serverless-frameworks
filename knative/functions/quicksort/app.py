import os

from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/')
def quicksort(req=''):
    if req == '':
        req = request.args.get('x')
    
    if isinstance(req, str):
        current_array = req.split(",")
        req = [int(numeric_string) for numeric_string in current_array]
    
    if len(req) <= 1:
        return req
    else:
        pivot = req[0]
        left = [x for x in req[1:] if x < pivot]
        right = [x for x in req[1:] if x >= pivot]
        return quicksort(left) + [pivot] + quicksort(right)

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
