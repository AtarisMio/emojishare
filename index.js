'use strict'
var express = require("express");
var path = require('path');
var src_path = path.join(__dirname, "source");
var app = express();
var request = require('request');
app.use(express.static(src_path));

app.get('/*',function(req,res){
    res.sendFile('index.html', {root: src_path});
});

app.listen(8080,function(){
    console.log("Listening on port "+this.address().port);
});