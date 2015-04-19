package models

/**
 * Created by roisin_jin on 14/04/2015.
 */
case class Port (name: String, locode: String, polygon: Polygon)
case class Polygon (lat: Double, lon: Double)

object JsonFormats {

  import play.api.libs.json.Json

  // Generates Writes and Reads for Polygon and Port
  implicit val polygonFormat = Json.format[Polygon]
  implicit val portFormat = Json.format[Port]
}
