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
from random import randint
import os
from PIL import Image

def main(dict):
    with Image.open(r"image.jpg") as image:
        MAX_SIZE = (100, 100)
        image.thumbnail(MAX_SIZE)
        result = 'thumb'+str(randint(100000000000, 999999999999))+'.jpg'
        image.save(result)
        return {"result": result}
    return {"result": "File not found in " + os.path.realpath(__file__)}