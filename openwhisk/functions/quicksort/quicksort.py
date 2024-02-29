"""OpenWhisk "Hello world" in Python.

/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"""

def quicksort(req):
    if len(req) <= 1:
        return req
    else:
        pivot = req[0]
        left = [x for x in req[1:] if x < pivot]
        right = [x for x in req[1:] if x >= pivot]
        return quicksort(left) + [pivot] + quicksort(right)

def main(dict):
    req = ""
    if 'x' in dict:
        req = dict['x']
    if isinstance(req, str):
        current_array = req.split(",")
        req = [int(numeric_string) for numeric_string in current_array]
    result = quicksort(req)
    return {"result": result}