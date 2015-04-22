
class ConfirmPortCtrl

	constructor: (@$log, @$modalInstance, @PortService, port_to_be_processed) ->
			@$log.debug "constructing DeletePortController"
			@port = port_to_be_processed
			@unit = 'm' if @port.limit
			@separator = ' , ' if @port.polygon and @port.polygon.lat and @port.polygon.lon
			@msg

	delete: () ->
				@$log.debug "deletePort()"
				name = @port.name
				@PortService.deletePort(@port)
				.then((status) =>
									@$log.debug "Port #{name} is deleted"
									@$modalInstance.close("confirm")
						,
						(error) =>
						       @$log.error "Unable to delete port: #{error}"
						       @msg = error
						)

	confirmNewPort: () ->
        @$log.debug "confirmNewPort()"
        @PortService.createPort(@port)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} port"
                @$modalInstance.close(data)
            ,
            (error) =>
                @$log.error "Unable to create port: #{error}"
                @msg = error
            )

	cancel: () -> @$modalInstance.dismiss("cancel")

controllersModule.controller('ConfirmPortCtrl', ConfirmPortCtrl)