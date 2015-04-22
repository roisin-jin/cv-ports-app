
class DeletePortCtrl

	constructor: (@$log, @$modalInstance, @PortService, port_to_be_deleted) ->
			@$log.debug "constructing DeletePortController"
			@port = port_to_be_deleted

	delete: () ->
				@$log.debug "deletePort()"
				name = @port.name
				@PortService.deletePort(@port)
				.then((status) =>
									@$log.debug "Port #{name} is deleted"
									@$modalInstance.close("confirm")
						,
						(error) => @$log.error "Unable to create port: #{error}"
						)

	cancel: () -> @$modalInstance.dismiss("cancel")

controllersModule.controller('DeletePortCtrl', DeletePortCtrl)