
class PortCtrl

    constructor: (@$log, @PortService) ->
        @$log.debug "constructing PortController"
        @ports = []
        @getAllPorts()

    getAllPorts: () ->
        @$log.debug "getAllPorts()"

        @PortService.listPorts()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Ports"
                @ports = data
            ,
            (error) =>
                @$log.error "Unable to get Ports: #{error}"
            )

controllersModule.controller('PortCtrl', PortCtrl)