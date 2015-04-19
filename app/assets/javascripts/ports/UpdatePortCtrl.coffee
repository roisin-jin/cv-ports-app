
class UpdatePortCtrl

	constructor: (@$log, @$location, @$routeParams, @PortService) ->
			@$log.debug "constructing UpdatePortController"
			@port = {}
			@findPort()

	updatePort: () ->
			@$log.debug "updatePort()"
			@PortService.updatePort(@$routeParams.name, @$routeParams.locode, @$routeParams.polygon, @port)
			.then(
					(data) =>
						@$log.debug "Promise returned #{data} Port"
						@port = data
						@$location.path("/")
				,
				(error) =>
						@$log.error "Unable to update Port: #{error}"
			)

	findPort: () ->
			# route params must be same name as provided in routing url in app.coffee
			name = @$routeParams.name
			locode = @$routeParams.locode
			@$log.debug "findPort route params: #{name} #{locode}"

			@PortService.listPorts()
			.then(
				(data) =>
					@$log.debug "Promise returned #{data.length} Ports"
					@port = (data.filter (port) -> port.name is name and port.locode is locode)[0]
			,
				(error) =>
					@$log.error "Unable to get ports: #{error}"
			)

controllersModule.controller('UpdatePortCtrl', UpdatePortCtrl)