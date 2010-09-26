-- hello lua
--
 json = require("json")
local response,panda
panda = "http://api.flickr.com/services/rest/?method=flickr.panda.getPhotos&api_key=23e6cbb669a2b007ca50b3829431c50d&panda_name=wang+wang&per_page=1&page=1"
response = socket.http.get(panda)
local o = json.decode(response.body)
table.foreach(o,print)


