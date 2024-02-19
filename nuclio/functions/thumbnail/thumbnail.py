from random import randint
from PIL import Image

def handler(context, event):
    image = Image.open(r"/home/nuclio/image.jpg")
    MAX_SIZE = (100, 100)
    image.thumbnail(MAX_SIZE)
    result = 'thumb'+str(randint(100000000000, 999999999999))+'.jpg'
    image.save(result)
    return context.Response(body='{"result": '+result+'}',
                            headers={},
                            content_type='text/plain',
                            status_code=200)
