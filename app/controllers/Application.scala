package controllers

import org.slf4j.{LoggerFactory, Logger}
import play.api.libs.json._
import scala.concurrent.Future

import reactivemongo.api.Cursor
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api._
import play.api.mvc._
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection

import models._
import models.ISOCountryFormats._
import models.JsonFormats._

object Application extends Controller with MongoController {

	private final val logger: Logger = LoggerFactory.getLogger(classOf[Application])

	def index = Action {
		logger.info("Serving index page...")
		Ok(views.html.index())
	}

	lazy val countryCollection: JSONCollection = db.collection[JSONCollection]("ISOCountries")
	def portsCollection: JSONCollection = db.collection[JSONCollection]("ports")

	def getISO3166CountryMap = Action.async {
		logger.info("Loading ISO 3166 Country list...")

		val cursor: Cursor[ISOCountry] = countryCollection.find(Json.obj()).sort(Json.obj("code" -> 1)).cursor[ISOCountry]
		val futureCountryList: Future[List[ISOCountry]] = cursor.collect[List]()
		val futureCountryMap: Future[Map[String,String]] =
			futureCountryList.map{ list => list.groupBy(ct=>ct.code).mapValues(list=>list.head.name)}

		val futureCountryMapJsonObj: Future[JsValue] = futureCountryMap.map {cMap => Json.toJson(cMap)}
		futureCountryMapJsonObj.map(re => Ok(re))
	}

	def deletePort(portName: String, locode: String) = Action.async {
		logger.info("Deleting port: " + portName)
		val portSelector = Json.obj("name" -> portName,
				"locode" -> Json.obj("country" -> locode.substring(0, 2), "port" -> locode.substring(2)))

		portsCollection.remove(portSelector, firstMatchOnly = true).map{
			lastError =>
					logger.debug(s"Successfully deleted port with LastError: $lastError")
					Created(s"Port deleted")
		}
	}

	def createPort = Action.async(parse.json) {
		request => request.body.validate[Port].map {
			port => portsCollection.insert(port).map {
						lastError =>
							logger.debug(s"Successfully inserted with LastError: $lastError")
							Created(s"Port Created")
					}
			}.getOrElse(Future.successful(BadRequest("invalid json")))
	}

	def updatePort(portName: String, locode: String) = Action.async(parse.json) {
		logger.info("Updating port: " + portName)
		request => request.body.validate[Port].map {
				port =>
					val portSelector = Json.obj("name" -> portName,
							"locode" -> Json.obj("country"->locode.substring(0, 2), "port"->locode.substring(2)))

					portsCollection.update(portSelector, port).map {
						lastError =>
							logger.debug(s"Successfully updated with LastError: $lastError")
							Created(s"Port Updated")
					}
			}.getOrElse(Future.successful(BadRequest("invalid json")))
	}

	def listAllPorts = Action.async {
		logger.info("List all ports")
		getPortsDataWithSelector(Json.obj()).map { ports => Ok(ports)}
	}

	def listPorts(frstChar: String) = Action.async {
		logger.info("List ports with locode starts with " + frstChar)
		val portsSelector = Json.obj("locode.country" -> Json.obj("$regex" -> "^".concat(frstChar)))
		// pick all ports with a locode starting as 'frstChar...'
		getPortsDataWithSelector(portsSelector).map { ports => Ok(ports)}
	}

	def getPortsDataWithSelector(portsSelector: JsObject): Future[JsValue] = {
		val futurePortsList: Future[List[Port]] =
			portsCollection.find(portsSelector).sort(Json.obj("locode" -> 1)).cursor[Port].collect[List]()
		val futurePortsMap: Future[Map[String, List[Port]]] =
			futurePortsList.map{ports => ports.groupBy(port => port.locode.country)}
		// first transform the ports list into a Map with country as the key, i.e: 'AU' -> List[Ports]
		// secondly transform the List[Ports] value to a JsArray
		futurePortsMap.map {pMap => Json.toJson(pMap)}
	}
}