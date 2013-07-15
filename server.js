var statik = require('statik');
statik({
    port: process.env.PORT,
    root: './public'
});