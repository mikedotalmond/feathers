feathers
========

Haxe externs for the Feathers UI framework - http://feathersui.com/

The library is definitely a work-in-progress and I expect there to be issues and missing implementations here and there.

I've included comments and metadata from the feathers source code where possible.

Feel free to report any problems :)

--

The feathers Haxe extern library can be found in lib/feathers
(it might end up on haxelib later)

To use this, you also need the starling library, a copy of which is included in lib/starling.

Feathers requires a newer version of starling than the current haxelib starling library has, 
so in lib/starling I've updated the externs with the latest changes and a rebuilt library swf.

The original starling lib: 
https://github.com/jgranick/starling / haxelib

My fork with updates: 
https://github.com/mikedotalmond/starling


The example project is a port of the feathers components explorer example - to test these externs..
http://feathersui.com/examples/components-explorer/
http://feathersui.com/examples/

I also ported the MetalWorksMobileTheme as part of this example - lib/MetalWorksMobileTheme