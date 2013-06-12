var page = require('webpage').create(),
    system = require('system'),
    address, output, size;

if (system.args.length < 4 || system.args.length > 6) {
    console.log('Usage: rasterize_element.js URL filename selector [paperwidth*paperheight|paperformat] [zoom]');
    console.log('  paper (pdf output) examples: "5in*7.5in", "10cm*20cm", "A4", "Letter"');
    phantom.exit(1);
} else {
    address = system.args[1];
    output = system.args[2];
    selector = system.args[3];
    page.viewportSize = { width: 600, height: 600 };
    if (system.args.length > 3 && system.args[2].substr(-4) === ".pdf") {
        size = system.args[3].split('*');
        page.paperSize = size.length === 2 ? { width: size[0], height: size[1], margin: '0px' }
                                           : { format: system.args[3], orientation: 'portrait', margin: '1cm' };
    }
    if (system.args.length > 4) {
        page.zoomFactor = system.args[4];
    }
        console.log("Loading page...");
    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
        } else {
            window.setTimeout(function () {
                console.log("Getting element clipRect...");
                var clipRect = page.evaluate(function (s) {
                        var cr = document.querySelector(s).getBoundingClientRect();
                        return cr;
                }, selector);
                
                page.clipRect = {
                        top:    clipRect.top,
                        left:   clipRect.left,
                        width:  clipRect.width,
                        height: clipRect.height
                };
                console.log("Rendering to file...");
                page.render(output);
                phantom.exit();
            }, 200);
        }
    });
}