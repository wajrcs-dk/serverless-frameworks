import os

from flask import Flask
from flask import request
from random import randint
from PIL import Image

app = Flask(__name__)

@app.route('/')
def thumbnail():
    image = Image.open(r"./image.jpg")
    MAX_SIZE = (100, 100)
    image.thumbnail(MAX_SIZE)
    result = 'thumb'+str(randint(100000000000, 999999999999))+'.jpg'
    image.save(result)
    return {"result": result}

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
