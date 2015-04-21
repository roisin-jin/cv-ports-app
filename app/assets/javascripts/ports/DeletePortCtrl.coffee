
class DeletePortCtrl

	constructor: (@$log, @$modalInstance, port_to_be_deleted) ->
			@$log.debug "constructing DeletePortController"
			@port = port_to_be_deleted

	delete: () -> @$modalInstance.close("confirm")
	cancel: () -> @$modalInstance.dismiss("cancel")

controllersModule.controller('DeletePortCtrl', DeletePortCtrl)