# thecatapi
api for thecatapi.com random cat image site
# Example
```nim
import asyncdispatch, thecatapi, json, strutils
let data = waitFor random_cat()
echo data
```

# Launch (your script)
```
nim c -d:ssl -r  your_app.nim
```
