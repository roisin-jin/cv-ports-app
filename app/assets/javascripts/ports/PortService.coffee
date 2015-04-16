
class PortService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$http, @$q) ->
        @$log.debug "constructing PortService"

    listPorts: () ->
        @$log.debug "listPorts()"
        deferred = @$q.defer()

        @$http.get("/ports")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Ports - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Ports - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    createPort: (port) ->
        @$log.debug "create port #{angular.toJson(port, true)}"
        deferred = @$q.defer()

        @$http.post('/port', port)
        .success((data, status, headers) =>
                @$log.info("Successfully created port - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create port - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    updatePort: (name, locode, polygon) ->
      @$log.debug "update port #{angular.toJson(port, true)}"
      deferred = @$q.defer()

      @$http.put("/port/#{name}/#{locode}/#{polygon}", port)
      .success((data, status, headers) =>
              @$log.info("Successfully updated port - status #{status}")
              deferred.resolve(data)
            )
      .error((data, status, header) =>
              @$log.error("Failed to update port - status #{status}")
              deferred.reject(data)
            )
      deferred.promise

servicesModule.service('PortService', PortService)