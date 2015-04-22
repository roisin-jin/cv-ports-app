
class PortService

		@headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
		@defaultConfig = { headers: @headers }

		constructor: (@$log, @$http, @$q) ->
				@$log.debug "constructing PortService"

		loadISOCountries: () ->
				deferred = @$q.defer()
				@$http.get("/getISOCountries")
				.success((data, status, headers) => deferred.resolve(data))
				.error((data, status, headers) => deferred.reject(data))

				deferred.promise

		listAllPorts: () ->
				@$log.debug "listPorts()"
				deferred = @$q.defer()

				@$http.get("/listAllPorts")
				.success((data, status, headers) =>
								@$log.debug("Successfully listed Ports - status #{status}")
								deferred.resolve(data)
						)
				.error((data, status, headers) =>
								@$log.error("Failed to list Ports - status #{status}")
								deferred.reject(data)
						)
				deferred.promise

		listPortsStartsWith: (frstChar) ->
				@$log.debug "listPortsStartsWith #{frstChar}"
				deferred = @$q.defer()

				@$http.get("/listPorts/#{frstChar}")
				.success((data, status, headers) =>
									@$log.debug("Successfully listed Ports with #{frstChar} - status #{status}")
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

				@$http.post('/newPort', port)
				.success((data, status, headers) =>
								@$log.debug("Successfully created port - status #{status}")
								deferred.resolve(data)
						)
				.error((data, status, headers) =>
								@$log.error("Failed to create port - status #{status}")
								deferred.reject(data)
						)
				deferred.promise
				
		deletePort: (port) ->
				deferred = @$q.defer()
				name = port.name
				locode = port.locode.country + port.locode.port
				@$log.debug "delete port #{name}, #{locode}"
				@$http.delete("/deletePort/#{name}/#{locode}")
						 .success((status, headers) =>
											 @$log.info("Successfully deleted port - status #{status}")
											 deferred.resolve(status))
						 .error((status, headers) => @$log.error("Failed to delete port - status #{status}"))
						 
				deferred.promise

		updatePort: (original_port, updated_port) ->
			@$log.debug "update port #{angular.toJson(original_port, true)}"
			deferred = @$q.defer()
			name = original_port.name
			locode = original_port.locode.country + original_port.locode.port
			@$http.put("/updatePort/#{name}/#{locode}", updated_port)
			.success((data, status, headers) =>
							@$log.debug("Successfully updated port - status #{status}")
							deferred.resolve(data)
						)
			.error((data, status, header) =>
							@$log.error("Failed to update port - status #{status}")
							deferred.reject(data)
						)
			deferred.promise

servicesModule.service('PortService', PortService)