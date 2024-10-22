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
    Canvas {
        id: txStreetCanvas
        anchors.fill: parent
    }
    Component {
        id: cImage
        Image {
            visible: false
        }
    }
    Component.onCompleted: {
        var dirs = ["right", "down", "left", "up"];

        var ctx;
        var textures = {};

        function dirIdx(x, y) {
            return (Math.round((Math.atan2(y,x)) / (Math.PI*2/dirs.length))
                %dirs.length+dirs.length)
                %dirs.length;
        }

        var texcache = {};
        var patterns = {};
        console.log("Whag??");

        function init() {
            textures.isabella = {};
            textures.eye = cImage.createObject(txStreet, {
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
                    vars.push(cImage.createObject(txStreet,{
                        source: "qrc:/Images/txstreet/isabella-"+dir+"-"+i+".png",
                    }));
                }
            }
        }

        var clr = 0;

        function drawIsabella(x, y, s, dx,dy,w) {
            ctx.save();
            ctx.translate(x, y);
            let diri = dirIdx(dx,dy);
            let mirror = false;
            let step = w!=null?Math.floor(w*1.5*(1/s))%3:1;
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
        }

        function draw(dt, w, h) {
            clr+=dt;
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
            ctx.fillRect(4,0, 0.125,h);
            ctx.fillStyle = "#55565a";
            ctx.fillRect(12,0, 3,h);
            ctx.fillStyle = "#ecdb9c";
            ctx.fillRect(12-0.05,0, 0.05,h);
            ctx.fillStyle = "#a3a4a6";
            for(let y=0; y<h; y+=2) {
                quasiRoundRect(12-0.1, y, 0.1, 1.98, 0.02);
            }
            drawIsabella(10.95,2.95,1, 0,1);
            {
                let ox,oy,px,py,x,y;
                [ox,oy] = [8,4];
                [px,py] = [ox+Math.sin((clr-dt)/3)*2,oy+Math.cos((clr-dt)/3)*2];
                [x,y] = [ox+Math.sin(clr/3)*2,oy+Math.cos(clr/3)*2];
                drawIsabella(x,y, 0.8, x-px,y-py, clr*(((x-px)**2+(y-py)**2)**0.5/Math.max(dt,0.0001)));
            }
        }

        (()=>{
            let t_begin;
            function animFrame(t) {
                if(t != undefined) {
                    if(t_begin == undefined) {
                        ctx = txStreetCanvas.getContext("2d");
                        t_begin = t;
                        init();
                    }
                    ctx.reset();
                    let ratio = txStreetCanvas.canvasSize.width / 15
                    ctx.scale(ratio, ratio);
                    draw(Math.min(t-t_begin,0.1), 15, txStreetCanvas.canvasSize.height / ratio);
                }
                txStreetCanvas.requestAnimationFrame(animFrame);
            }
            animFrame();
        })();
    }
}
