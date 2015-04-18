package controllers

import org.slf4j.{LoggerFactory, Logger}
import play.api.libs.json.{JsValue, JsArray}
import play.api.libs.json.Json._
import scala.concurrent.Future
import reactivemongo.api.Cursor
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api._
import play.api.mvc._
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection

object Application extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[Application])

  def index = Action {
    logger.info("Serving index page...")
    Ok(views.html.index())
  }

  def collection: JSONCollection = db.collection[JSONCollection]("ports")

  import models._
  import models.JsonFormats._

  def createPort = Action.async(parse.json) {
    request => request.body.validate[Port].map {
      port => collection.insert(port).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Created(s"Port Created")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def updatePort(portName: String, locode: String, polygon: Polygon) = Action.async(parse.json) {
    request => request.body.validate[Port].map {
        port => val portSelector = obj("name" -> portName, "locode" -> locode, "polygon" -> polygon)
          collection.update(portSelector, port).map {
            lastError =>
              logger.debug(s"Successfully updated with LastError: $lastError")
              Created(s"Port Updated")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def listPorts = Action.async {
    val cursor: Cursor[Port] = collection.find().sort(obj("created" -> -1)).cursor[Port]
    // gather all the JsObjects in a list
    val futurePortsList: Future[List[Port]] = cursor.collect[List]()
    // transform the list into a JsArray
    val futurePortsJsonArray: Future[JsArray] = futurePortsList.map { ports => arr(ports)}
    // everything's ok! Let's reply with the array
    futurePortsJsonArray.map { ports => Ok(ports(0))}
  }

  def findPortsWithLocodeStartsWith(frstChar: String) = Action.async {
    val portsSelector = obj("name" -> obj("$regex" -> ("^" + frstChar + ".+")))
    // pick all ports with a locode starting as 'frstChar...'
    val cursor: Cursor[Port] = collection.find(portsSelector).sort(obj("name" -> 1)).cursor[Port]
    val futurePortsMap: Future[Map[String, JsArray]] = cursor.collect[List]()
      .map(ports => ports.groupBy(port => port.name.substring(0, 2)))
      .map(portsMap => portsMap.mapValues(ports => arr(ports)))
    // first transform the ports list into a Map with country as the key, i.e: 'AU' -> List[Ports]
    // secondly transform the List[Ports] value to a JsArray

    val futurePortsMapJsonObj: Future[JsValue] = futurePortsMap.map {pMap => toJson(pMap)}

    futurePortsMapJsonObj.map { ports => Ok(ports(0))}
  }
}