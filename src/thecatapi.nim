import asyncdispatch, httpclient, json, strutils, uri

const api = "https://api.thecatapi.com/v1"
var headers = newHttpHeaders({
    "Connection": "keep-alive",
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    "Host": "api.thecatapi.com",
    "Accept": "application/json"
})

proc random_cat*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "/images/search")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc search_cat*(limit: int = 10, breed_ids: string = ""): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  
  # Строим URL с параметрами
  var url = api & "/images/search?limit=" & $limit
  if breed_ids != "":
    url &= "&breed_ids=" & breed_ids
  
  try:
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Получить список пород
proc get_breeds*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "/breeds")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Получить информацию о породе по ID
proc get_breed*(breed_id: string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "/breeds/" & breed_id)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Поиск пород по названию
proc search_breeds*(q: string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let encoded = encodeUrl(q)
    let response = await client.get(api & "/breeds/search?q=" & encoded)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Получить категории
proc get_categories*(): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "/categories")
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Поиск изображений с дополнительными параметрами
proc search_cat_advanced*(
    limit: int = 10,
    breed_ids: string = "",
    category_ids: string = "",
    mime_types: string = "",
    order: string = "RANDOM"
): Future[JsonNode] {.async.} =
  
  let client = newAsyncHttpClient()
  client.headers = headers
  
  var url = api & "/images/search?limit=" & $limit & "&order=" & order
  
  if breed_ids != "":
    url &= "&breed_ids=" & breed_ids
  if category_ids != "":
    url &= "&category_ids=" & category_ids
  if mime_types != "":
    url &= "&mime_types=" & mime_types
  
  try:
    let response = await client.get(url)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

# Получить информацию об изображении по ID
proc get_image*(image_id: string): Future[JsonNode] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let response = await client.get(api & "/images/" & image_id)
    let body = await response.body
    result = parseJson(body)
  finally:
    client.close()

proc save_image*(url:string,filename:string):Future[bool] {.async.} =
  let client = newAsyncHttpClient()
  client.headers = headers
  try:
    let req = await client.get(url)
    let content = await req.body
    if content.len > 0:
        writeFile(filename, content)
        return true
  finally:
    client.close()
