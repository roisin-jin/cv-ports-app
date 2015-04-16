
dependencies = [
    'ngRoute',
    'ui.bootstrap',
    'uiGmapgoogle-maps',
    'cvPortsApp.services',
    'cvPortsApp.controllers',
    'cvPortsApp.routeConfig'
]

app = angular.module('cvPortsApp', dependencies)

angular.module('cvPortsApp.routeConfig', ['ngRoute'])
    .config ($routeProvider) ->
        $routeProvider
            .when('/', {
                templateUrl: '/assets/partials/view.html'
            })
            .when('/ports/create', {
                templateUrl: '/assets/partials/create.html'
            })
            .when('/ports/edit/:name/:locode/:polygon', {
                templateUrl: '/assets/partials/update.html'
            })
            .otherwise({redirectTo: '/'})
    .config ($locationProvider) ->
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        })


@controllersModule = angular.module('cvPortsApp.controllers', [uiGmapgoogle-maps])
                            .config ($uiGmapGoogleMapApiProvider) ->
                                   $uiGmapGoogleMapApiProvider.configure({
                                      //key: 'your api key',
                                      v: '3.17',
                                      libraries: 'geometry,visualization'})

@servicesModule = angular.module('cvPortsApp.services', [])
@modelsModule = angular.module('cvPortsApp.models', [])