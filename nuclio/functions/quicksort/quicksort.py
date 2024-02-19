import json

def quicksort(req):
    if len(req) <= 1:
        return req
    else:
        pivot = req[0]
        left = [x for x in req[1:] if x < pivot]
        right = [x for x in req[1:] if x >= pivot]
        return quicksort(left) + [pivot] + quicksort(right)

def handler(context, event):
    req = "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2"
    if isinstance(req, str):
        current_array = req.split(",")
        req = [int(numeric_string) for numeric_string in current_array]
    result = quicksort(req)
    
    return context.Response(body='{"result": '+json.dumps(result)+'}',
                            headers={},
                            content_type='text/plain',
                            status_code=200)
