
class TabSetCtrl

      contructor: () ->
        @tabs = [{
                  "heading": "Home",
        		  "active": true,
        		  "template":"/assets/partials/view.html"
        		  },
        		  {
        		   "heading": "Add Port",
        		   "active": false,
        		   "template":"/assets/partials/create.html"
        		   },
        		   {
        			"heading": "About",
        			"active": false,
        			"template":"/assets/partials/about.html"
        			}]


controllersModule.controller('TabSetCtrl', TabSetCtrl)