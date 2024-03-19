from random import randint
from PIL import Image

def handle(req):
    image = Image.open(r"/home/app/image.jpg")
    MAX_SIZE = (100, 100)
    image.thumbnail(MAX_SIZE)
    result = 'thumb'+str(randint(100000000000, 999999999999))+'.jpg'
    image.save(result)
    return {"result": result}
