controllersModule.controller('TabSetCtrl', function(){
this.tab = 1;
this.tabs = [{id:1, heading:"Home", goto: "/#/listPorts"},
             {id:2, heading: "Add Port", goto: "/#/port/create"},
             {id:3, heading: "About", goto: "/#/about"}];

this.setTab = function (tabId) { this.tab = tabId;};
this.isSet = function (tabId) { return this.tab === tabId;};
});