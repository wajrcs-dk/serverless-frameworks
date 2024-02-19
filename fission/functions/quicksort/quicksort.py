from flask import request

def quicksort(req):
    if len(req) <= 1:
        return req
    else:
        pivot = req[0]
        left = [x for x in req[1:] if x < pivot]
        right = [x for x in req[1:] if x >= pivot]
        return quicksort(left) + [pivot] + quicksort(right)

def main():
    req = request.args.get('x')
    if isinstance(req, str):
        current_array = req.split(",")
        req = [int(numeric_string) for numeric_string in current_array]
    result = quicksort(req)
    return {"result": result}
