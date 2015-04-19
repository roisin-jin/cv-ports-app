dependencies = [
	'ngRoute',
	'ui.bootstrap',
	'cvPortsApp.services',
	'cvPortsApp.controllers'
]

app = angular.module('cvPortsApp', dependencies)
app.config ($locationProvider) ->
		$locationProvider.html5Mode({
			enabled: true,
			requireBase: false
		})

@controllersModule = angular.module('cvPortsApp.controllers', [])
@servicesModule = angular.module('cvPortsApp.services', [])