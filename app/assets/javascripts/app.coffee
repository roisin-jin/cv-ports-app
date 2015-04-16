var app, dependencies;

dependencies = ['ngRoute', 'ui.bootstrap', 'cvPortsApp.services', 'cvPortsApp.controllers', 'cvPortsApp.directives', 'cvPortsApp.common', 'cvPortsApp.routeConfig'];

app = angular.module('cvPortsApp', dependencies);

angular.module('cvPortsApp.routeConfig', ['ngRoute']).config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: '/assets/partials/view.html'
  }).when('/users/create', {
    templateUrl: '/assets/partials/create.html'
  }).when('/users/edit/:firstName/:lastName', {
    templateUrl: '/assets/partials/update.html'
  }).otherwise({
    redirectTo: '/'
  });
}).config(function($locationProvider) {
  return $locationProvider.html5Mode({
    enabled: true,
    requireBase: false
  });
});

this.commonModule = angular.module('cvPortsApp.common', []);

this.controllersModule = angular.module('cvPortsApp.controllers', []);

this.servicesModule = angular.module('cvPortsApp.services', []);

this.modelsModule = angular.module('cvPortsApp.models', []);

this.directivesModule = angular.module('cvPortsApp.directives', []);