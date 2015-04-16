
class PortCtrl

    constructor: (@$log, @PortService) ->
        @$log.debug "constructing PortController"
        @ports = []
        @gmarkers = []
        @getAllPortsAndMarkers()

    getAllPortsAndMarkers: () ->
        @$log.debug "getAllPorts()"

        @PortService.listPorts()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Ports"

                @ports = data

                for port in @ports:
                    @gmarkers.push new google.maps.LatLng(port.polygon.lan, port.polygon.lon)
            ,
            (error) =>
                @$log.error "Unable to get Ports: #{error}"
            )

controllersModule.controller('PortCtrl', PortCtrl)