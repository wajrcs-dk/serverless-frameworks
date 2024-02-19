from flask import request

def main():
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