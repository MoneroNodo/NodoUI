import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: txStreet
    anchors.fill: parent
    signal deleteMe(int screenID)

    Component {
        id: cCanvas
        Canvas {}
    }

    Component {
        id: cImage
        Image {}
    }

    FrameAnimation {
        id: scrAnim
        running: true
    }

    Component.onCompleted: { var boot = () => {
        for (let c of [cCanvas, cImage]) {
            if(c.status != Component.Ready) {
                return c.statusChanged.connect(boot);
            }
        }

        const PICONERO = 1e-12;
        const LOOK_DEPTH = 30;
        const MAX_REORG = 5;

        var dirs = ["right", "down", "left", "up"];

        var textures = {};
        var postLight = 0;
        var postCanvas;
        var ratio = 0;
        var ctx;
        var blocks = new Map();
        var isabellas = new Map();

        var monerod = "http://127.0.0.1:"+nodoConfig.getIntValueFromKey("config", "monero_public_port");

        function newCanvas(w, h) {
            let canvas = cCanvas.createObject(txStreet,{
                x:0,
                y:0,
                width: w??txStreet.width,
                height: h??txStreet.height,
            });
            return canvas;
        }

        function newIsabella(tx) {
            let obj = {};
        }

        function mergeSeq(arrs, cmp) {
            let o = [];
            let idx = new Map();
            for (let arr of arrs) {
                if (arr.length > 0)
                    idx.set(arr, 0);
            }
            while (idx.size > 0) {
                let best_e, best_val;
                for (let [arr, i] of idx.entries()) {
                    if (best_e == null || cmp(best_val, arr[i]) > 0) {
                        best_e = arr; best_val = arr[i];
                    }
                }
                o.push(best_val);
                let i = idx.get(best_e) + 1;
                if (i >= best_e.length)
                    idx.delete(best_e);
                else
                    idx.set(best_e, i);
            }
            return o;
        }

        function sendRequest(url, body) {
            let p,q;
            let promise = new Promise((f,n)=>(p=f,q=n));
            let request = new XMLHttpRequest();
            if (url!="/json_rpc") console.log("REQ ",url);
            request.onreadystatechange = function () {
                if(request.readyState != XMLHttpRequest.DONE) return;
                if(request.status != 200) {
                    console.error(url,"FAIL",request.status,request.responseText);
                    q(request);
                    return;
                }
                p({
                    status : request.status,
                    headers : request.getAllResponseHeaders(),
                    content : request.responseText
                });
            }
            request.open(body!=null?"POST":"GET", monerod+url);
            if(body!=null) request.send(body);
            else request.send();
            return promise;
        }

        function sendJsonRpc(method, params, fun) {
            console.log("JSON",method);
            return sendRequest("/json_rpc", JSON.stringify({
                "jsonrpc": "2.0",
                "id":"0",
                "method": method,
                "params": params
            })).then(function(req) {
                return JSON.parse(req.content).result
            });
        }

        var fetchInterval = 3;
        var toFetch = 0;

        function finwrap(f) {
            return [_=>f(),e=>{f();throw e}];
        }

        function fetchInfo() {
            var info = {};

            Promise.all([
                sendRequest("/get_transaction_pool").then(function(res) {
                    res = JSON.parse(res.content);
                    if (res.status != "OK") throw "RPC Error";
                    info.txs_pool = res.transactions.map(e=>({
                        id: e.id_hash,
                        weight: e.blob_size,
                        fee: e.fee,
                    }));
                }),

                sendJsonRpc("get_miner_data", []).then(function(res) {
                    if(res.status != "OK") throw "RPC Error";
                    info.miner_txs = res.tx_backlog??[];
                }),

                sendJsonRpc("get_info", []).then(function(res) {
                    info.blocksize = res.block_weight_limit;
                    info.height = res.height;
                    let proms = [];
                    for (let i = info.height - LOOK_DEPTH; i < info.height; i++) {
                        proms.push(Promise.resolve()
                            .then(_=>{
                                if (!blocks.has(i))
                                    return true;
                                if (i < info.height - MAX_REORG)
                                    return false;
                                return sendJsonRpc("get_block_header_by_height",{height: i})
                                    .then(blk => blk.block_header.hash != blocks.get(i).hash)
                            })
                            .then(b => {
                                if (!b) return false;
                                return sendJsonRpc("get_block", {height: i}).then(blk => {
                                    blk = Object.assign({},
                                        blk.block_header,
                                        JSON.parse(blk.json)
                                    );
                                    let blkinfo = {hash:blk.hash, height: i, txs:[]};
                                    let txl = blk.tx_hashes;
                                    let txls = [];
                                    for (let t, i = 0; t=txl.slice(i,i+100), t.length > 0; i+=100) {
                                        txls.push(t); t.i=i;
                                    }
                                    function flat(arr) {
                                        let o = [];
                                        for(let v of arr) {
                                            for (let vv of v) {
                                                o.push(vv);
                                            }
                                        }
                                        return o;
                                    }
                                    return Promise.all(txl.length > 0 ? flat(txls.map(txl => [

                                        sendRequest("/get_transactions",JSON.stringify({
                                            txs_hashes: txl, decode_as_json: true, prune: true
                                        }))
                                        .then(e => JSON.parse(e.content))
                                        .then(txs => {
                                            if(txs.missed_tx && txs.missed_tx.length > 0)
                                                throw "Tx gone";
                                            if(txs.txs == null)
                                                throw "No txs?? "+JSON.stringify(txl)+JSON.stringify(txs);
                                            return txs;
                                        })
                                        .then(txs => txs.txs.forEach((tx,i) => {
                                            blkinfo.txs[i+txl.i] = blkinfo.txs[i+txl.i]??{id:tx.tx_hash};
                                            blkinfo.txs[i+txl.i].fee = JSON.parse(tx.as_json).rct_signatures.txnFee
                                        })),

                                        sendRequest("/get_transactions",JSON.stringify({
                                            txs_hashes: txl
                                        }))
                                        .then(e => JSON.parse(e.content))
                                        .then(txs => {
                                            if(txs.missed_tx && txs.missed_tx.length > 0)
                                                throw "Tx gone";
                                            if(txs.txs == null)
                                                throw "No txs?? "+JSON.stringify(txl)+JSON.stringify(txs);
                                            return txs;
                                        })
                                        .then(txs => txs.txs.forEach((tx,i) => {
                                            blkinfo.txs[i+txl.i] = blkinfo.txs[i+txl.i]??{id:tx.tx_hash};
                                            blkinfo.txs[i+txl.i].weight = tx.as_hex.length / 2
                                        })),

                                    ])) : [])
                                    .then(_ => blocks.set(i, blkinfo))
                                    .then(_ => {
                                        let fees = [];
                                        for (let tx of blkinfo.txs) {
                                            fees.push(tx.fee);
                                        }
                                        blkinfo.fees = fees.sort((a,b)=>a-b);
                                    })
                                    .then(_ => true)
                                })
                            })
                        )
                    }
                    return Promise.all(proms);
                }),
            ]).then(_=>{
                processInfo(info);
            }).then(...finwrap(_=>{
                toFetch = fetchInterval;
            })).catch(e=>{
                console.error(e);
                console.error(e.stack);
            });
        }

        function processInfo(info) {
            let bus = new Set();
            for (let i of info.miner_txs) {
                bus.add(i.id);
            }
            let sum = 0;
            info.pending = 0;
            let fees = [];
            for(let i of info.txs_pool) {
                if(bus.has(i.id)) {
                    sum+=i.weight;
                }
                fees.push(i.fee);
                info.pending++;
            }
            let mergables = [fees.sort()];
            for(let [h,blk] of blocks) {
                if(h<info.height-LOOK_DEPTH) {
                    blocks.delete(h);
                } else {
                    mergables.push(blk.fees);
                }
            }
            fees = mergeSeq(mergables, (a,b) => a-b);
            info.median_fee = fees[Math.floor(fees.length / 2)] ?? 0;
            let ticker = priceTicker.getCurrency();
            console.log("Xmr","=",ticker);
            console.log((sum / info.blocksize)*100 + "% full, "+info.pending+" pending, median fee: " + info.median_fee * PICONERO * ticker + ", "+fees.length+" total");
        }

        function dirIdx(x, y) {
            return (Math.round((Math.atan2(y,x)) / (Math.PI*2/dirs.length))
                %dirs.length+dirs.length)
                %dirs.length;
        }

        function init() {
            textures.isabella = {};
            textures.eye = cImage.createObject(null, {
                source: "qrc:/Images/eye.png"
            });
            for(let dir of dirs) {
                let vars = [];
                let mirror = false;
                if (dir == "right") {
                    continue;
                }
                textures.isabella[dir] = vars;
                for(let i=0; i<3; i++) {
                    vars.push(cImage.createObject(null,{
                        source: "qrc:/Images/txstreet/isabella-"+dir+"-"+i+".png",
                    }));
                }
            }
        }

        function canvasDraw(canvas, fun) {
            ctx = canvas.getContext("2d");
            ctx.save();
            ctx.strokeStyle="#00000000";
            ctx.scale(ratio,ratio);
            fun(canvas.height / ratio);
            ctx.restore();
        }

        var clr = 0;

        function drawIsabella(x, y, s, dx,dy,w) {
            ctx.save();
            ctx.translate(x, y);
            let diri = dirIdx(dx,dy);
            let mirror = false;
            let step = w!=null?(Math.floor(w*2*(1/s))%2)*2/1:1;
            if(dirs[diri]=="right") {
                mirror = true;
                step = 2-step;
                diri = dirIdx(-dx, dy);
            }
            let tex = textures.isabella[dirs[diri]][step];
            let texsc = tex.sourceSize.width;
            ctx.scale(s*(mirror?-1:1), s);
            ctx.translate(-0.5,-0.96);
            ctx.scale(1/texsc,1/texsc);
            ctx.drawImage(tex,0,0,texsc,texsc);
            ctx.restore();
        }

        function quasiRoundRect(x,y,w,h,rad) {
            ctx.beginPath();
            ctx.moveTo(x,y+rad);
            ctx.lineTo(x,y+h-rad);
            ctx.lineTo(x+rad,y+h);
            ctx.lineTo(x+w-rad,y+h);
            ctx.lineTo(x+w,y+h-rad);
            ctx.lineTo(x+w,y+rad);
            ctx.lineTo(x+w-rad,y);
            ctx.lineTo(x+rad,y);
            ctx.fill();
            ctx.closePath();
            ctx.stroke();
        }

        function mulberry32(a) {
            return function() {
                a |= 0; a = a + 0x6D2B79F5 | 0;
                var t = Math.imul(a ^ a >>> 15, 1 | a);
                t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
                return ((t ^ t >>> 14) >>> 0) / 4294967296;
            }
        }

        let cloudcache = {};

        function cloud(seed, x,y, t) {
            ctx.save();
            ctx.translate(x,y);
            var rand = mulberry32(seed);
            for(let i=0; i<3; i++) {
                ctx.beginPath();
                let w = (0.95+rand()*0.1) * 1.1;
                ctx.ellipse(x+(i-1)*2+rand(),y+rand(),w,w,0,0,Math.PI*2);
                console.log(x+(i-1)*2+rand(),y+rand(),w,w,0,0,Math.PI*2)
                ctx.fill();
            }
            ctx.restore();
        }

        function drawBg(h) {
            ctx.fillStyle = "#7f8084";
            ctx.fillRect(4,0, 8,h)
            ctx.fillStyle = "#828386"
            for(let x=0; x<8; x++)
            for(let y=0; y<h; y++) {
                if((x+y)%2==0) {
                    quasiRoundRect(4+x,y,1,1,0.07);
                }
            }
            ctx.fillStyle = "#f0de9c";
            ctx.fillRect(0,0, 4,h);
            ctx.fillStyle = "#f0d329";
            ctx.fillRect(3.95,0, 0.125,h);

            ctx.fillStyle = "#55565a";
            ctx.fillRect(12,0, 3,h);
            ctx.fillStyle = "#7c804b";
            ctx.fillRect(12.2,0, 0.1,h);
            ctx.fillRect(14.8,0, 0.1,h);

            ctx.fillStyle = "#ecdb9c";
            ctx.fillRect(12,0, 0.05,h);
            ctx.fillStyle = "#a3a4a6";
            for(let y=0; y<h; y+=2) {
                quasiRoundRect(12-0.1+0.05, y, 0.125, 1.98, 0.02);
            }
            for(let [x,y] of [[5-0.24,2+0.24],[5-0.24+6.7,2+0.24]]) {
                ctx.save();
                ctx.translate(x,y);
                ctx.fillStyle = "#a3a4a6";
                quasiRoundRect(-0.625/2,-0.625/2+0.05,0.625,0.625,0.11);
                ctx.fillStyle = "#b0b2b4";
                quasiRoundRect(-0.625/2,-0.625/2,0.625,0.625,0.11);
                ctx.fillStyle = "#a3a4a6";
                quasiRoundRect(-0.1,-2,0.2,2.1,0.05);
                ctx.restore();
            }
            ctx.fillStyle = "#212121";
            ctx.fillRect(5-0.24+0.1,0.24,6.5,1.4);
            drawIsabella(10.95,2.95,1, 0,1);
        }

        function drawPostlight() {
            ctx.save();
            ctx.translate(-12,0);
            ctx.translate(14.95, 2.5);
            ctx.fillStyle = "#a3a4a6";
            quasiRoundRect(-0.625/2,-0.625/2+0.05,0.625,0.625,0.11);
            ctx.fillStyle = "#b0b2b4";
            quasiRoundRect(-0.625/2,-0.625/2,0.625,0.625,0.11);
            ctx.fillStyle = "#a3a4a6";
            quasiRoundRect(-0.1,-2,0.2,2.1,0.05);
            quasiRoundRect(-2.23,-2,2.23,0.2,0.05);
            ctx.fillRect(-1.45+0.15,-2,0.13,0.5);
            ctx.fillRect(-1.45+1.16-0.15-0.13,-2,0.13,0.5);
            ctx.save();
            ctx.translate(-2.23,-2.23);
            ctx.fillStyle = "#202020"
            quasiRoundRect(0,0,0.6,1.2,0.025);
            for(let [i,off,on] of [
                [0,"#4d2525","#ff3838"],
                [1,"#4c4d25","#fdff38"],
                [2,"#264d25","#7eff7b"],
            ]) {
                ctx.fillStyle = i==postLight ? on : off;
                ctx.beginPath();
                ctx.arc(0.3,0.25+i*0.35,0.14,0,Math.PI*2);
                ctx.fill();
            }
            ctx.restore();
            ctx.fillStyle = "#377249";
            quasiRoundRect(-1.45,-1.67,1.16,0.83, 0.04);
            ctx.fillStyle = "#00000000";
            ctx.strokeStyle = "#ffffff";
            ctx.lineWidth = 0.01;
            quasiRoundRect(-1.45+1/32,-1.67+1/32,1.16-1/16,0.83-1/16, 0.02);
            ctx.fillStyle = "#ffffff";
            ctx.strokeStyle = "#00000000";
            ctx.save()
            ctx.translate(-1.45+1.16/2,-1.67+0.8*0.8);
            ctx.beginPath();
            ctx.moveTo(-0.02,-0.145);
            ctx.lineTo(-0.02,-0.27);
            ctx.lineTo(-0.11,-0.27);
            ctx.lineTo(0,-0.57);
            ctx.lineTo(0.11,-0.27);
            ctx.lineTo(0.02,-0.27);
            ctx.lineTo(0.02,-0.145);
            ctx.fill();
            ctx.scale(0.19/20*0.84,0.19/20);
            ctx.font = "bold 20px sans-serif";
            ctx.textAlign = "center";
            ctx.fillText("Blockchain",0,4);
            ctx.restore();
            ctx.restore();
        }

        function update(dt, w, h) {
            toFetch-=dt;
            if(toFetch<=0) {
                toFetch=Infinity;
                fetchInfo();
            }
            clr+=dt;
            /*
            ((_clr)=>{
                for (let i=0;i<10; i++){
                    let clr = _clr +i*0.1;
                    let ox,oy,px,py,x,y;
                    let ttp = (clr-dt)*2;
                    let tt = clr*2;
                    [ox,oy] = [8,4];
                    [px,py] = [ox+Math.sin((ttp))*2,oy+Math.cos((ttp))*2];
                    [x,y] = [ox+Math.sin(tt)*2,oy+Math.cos(tt)*2];
                    drawIsabella(x,y, 0.5, x-px,y-py, clr*(((x-px)**2+(y-py)**2)**0.5/Math.max(dt,0.0001)));
                }
            })(clr)

            {
            }

            ctx.fillStyle = "#ffffff";
            //cloud(42,8,4, clr);*/
        }

        function setCanvasPosition(canvas, x, y, w ,h) {
            x *= ratio; y *= ratio;
            w *= ratio; h *= ratio;
            if (canvas.x != x || canvas.y != y) {
                canvas.x = x; canvas.y = y;
            }
            if (canvas.width != w || canvas.height != h) {
                canvas.width = w; canvas.height = h;
                canvas.requestPaint();
                console.log("repaint!");
                if(canvas.canvasSize.width != w) throw "Wtf";
            }
        }

        function layout() {
            let z = 0;
            return function(canvas) {
                if(canvas.z != z) {
                    canvas.z = z;
                }
                z++;
            }
        }

        (()=>{
            init();
            let t_begin;
            let counter = 0;
            let dt = 0;
            let bgCanvas = newCanvas();
            postCanvas = newCanvas();
            ratio = txStreet.width / 15;
            scrAnim.onTriggered.connect(function() {
                let lay = layout();
                ratio = txStreet.width / 15;
                setCanvasPosition(bgCanvas, 0, 0, 15, txStreet.height / ratio);
                setCanvasPosition(postCanvas, 12, 0, 4, 3);
                update(scrAnim.frameTime);
                lay(bgCanvas);
                lay(postCanvas);
            });
            bgCanvas.onPaint.connect(function() {
                canvasDraw(bgCanvas, drawBg);
            });
            postCanvas.onPaint.connect(function() {
                canvasDraw(postCanvas, drawPostlight);
            });
        })();
    }; boot(); }
}
