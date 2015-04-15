package controllers

import org.slf4j.{LoggerFactory, Logger}
import scala.concurrent.Future
import reactivemongo.api.Cursor
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api._
import play.api.mvc._
import play.api.libs.json._
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection

object Application extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[Application])

  def index = Action {
    logger.info("Serving index page...")
    Ok(views.html.index("Hello Roisin!"))
  }

  def collection: JSONCollection = db.collection[JSONCollection]("ports")

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

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
        port => val nameSelector = Json.obj("portName" -> portName, "locode" -> locode, "polygon" -> polygon)
          collection.update(nameSelector, port).map {
            lastError =>
              logger.debug(s"Successfully updated with LastError: $lastError")
              Created(s"Port Updated")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def listPorts = Action.async {
    val cursor: Cursor[Port] = collection.find().sort(Json.obj("created" -> -1)).cursor[Port]
    // gather all the JsObjects in a list
    val futurePortsList: Future[List[Port]] = cursor.collect[List]()
    // transform the list into a JsArray
    val futurePortsJsonArray: Future[JsArray] = futurePortsList.map { ports => Json.arr(ports)}
    // everything's ok! Let's reply with the array
    futurePortsJsonArray.map { ports => Ok(ports(0))}
  }
}