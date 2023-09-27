var http = require('http');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  var url = req.url;
  console.log(url);
  if(url ==='/admin'){
     res.end("SECRET!!!\n");
  } else {
     res.end("hello\n");
  }
}).listen(8000, function(){
  console.log("server start at port 8000");
});

