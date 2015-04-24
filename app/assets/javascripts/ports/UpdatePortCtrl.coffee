
class UpdatePortCtrl

	constructor: (@$log, @$modalInstance, @$rootScope, @PortService, port_to_be_updated) ->
			@$log.debug "constructing UpdatePortController"
			@original_port = port_to_be_updated
			@updated_port = angular.copy(port_to_be_updated)

			@countryOptions = (@createCountryOption key, value for key, value of @$rootScope.ISOCountries)
			@countryOptions.sort((a,b) -> a.value.localeCompare(b.value))
			@msg

	createCountryOption: (code, name) -> {label: code + ' - ' + name, value: code}

	assignCountryValue: (value) -> @port.locode.country = value

	resetAll: () -> @updated_port = angular.copy(@original_port)

	updatePort: () ->
			@updated_port.name = @updated_port.name.charAt(0).toUpperCase() + @updated_port.name.slice(1)
			@updated_port.locode.country = @updated_port.locode.country.toUpperCase()
			@updated_port.locode.port = @updated_port.locode.port.toUpperCase()

			@PortService.updatePort(@original_port, @updated_port)
						.then((data) =>
								  @$log.debug "Promise returned #{data} Port"
								  @$modalInstance.close(@updated_port)
							  ,
							  (error) =>
								  @$log.error "Unable to update Port: #{error}"
								  @msg = "Port with the same locode already existed!"
							  )

	cancel: () ->
		   @$log.debug "No update needed"
		   @$modalInstance.dismiss('cancel')

controllersModule.controller('UpdatePortCtrl', UpdatePortCtrl)