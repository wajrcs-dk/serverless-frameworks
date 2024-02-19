from flask import request
from random import randint
from PIL import Image

def main():
    image = Image.open(r"/app/image.jpg")
    MAX_SIZE = (100, 100)
    image.thumbnail(MAX_SIZE)
    result = '/app/thumb'+str(randint(100000000000, 999999999999))+'.jpg'
    image.save(result)
    return {"result": result}