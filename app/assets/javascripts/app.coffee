
dependencies = [
    'ngRoute',
    'ui.bootstrap',
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
            .when('/users/create', {
                templateUrl: '/assets/partials/create.html'
            })
            .when('/users/edit/:name/:locode/:polygon', {
                templateUrl: '/assets/partials/update.html'
            })
            .otherwise({redirectTo: '/'})
    .config ($locationProvider) ->
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        })

@controllersModule = angular.module('cvPortsApp.controllers', [])
@servicesModule = angular.module('cvPortsApp.services', [])
@modelsModule = angular.module('cvPortsApp.models', [])