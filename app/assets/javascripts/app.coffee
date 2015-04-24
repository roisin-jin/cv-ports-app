dependencies = [
	'ngRoute',
	'ui.bootstrap',
	'uiGmapgoogle-maps',
	'cvPortsApp.services',
	'cvPortsApp.controllers',
	'cvPortsApp.routeConfig',
	'cvPortsApp.filters',
]

app = angular.module('cvPortsApp', dependencies)

angular.module('cvPortsApp.routeConfig', ['ngRoute'])
	.config ($routeProvider) ->
			$routeProvider
				.when('/', {templateUrl: '/assets/partials/viewPorts.html'})
				.when('/listPorts', {templateUrl: '/assets/partials/viewPorts.html'})
				.when('/listPorts/:frstLetter', {templateUrl: '/assets/partials/viewPorts.html'})
				.when('/port/create', {templateUrl: '/assets/partials/createPort.html'})
				.when('/about', {templateUrl: '/assets/partials/about.html'})
				.otherwise({redirectTo: '/'})
	.config ($locationProvider) ->
		$locationProvider.html5Mode({
			enabled: true,
			requireBase: false
		})

@controllersModule = angular.module('cvPortsApp.controllers', ['ui.bootstrap', 'uiGmapgoogle-maps'])
							.config(['uiGmapGoogleMapApiProvider',  (uiGmapGoogleMapApi) ->
                              uiGmapGoogleMapApi.configure({
                                v: '3.18',
                                libraries: 'geometry,visualization'
                              })])

@servicesModule = angular.module('cvPortsApp.services', [])
@filtersModule = angular.module('cvPortsApp.filters', [])