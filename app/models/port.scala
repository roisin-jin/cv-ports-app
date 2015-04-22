package models

/**
 * Created by roisin_jin on 14/04/2015.
 */
case class Port (locode: Locode, name: String, polygon: Option[Polygon], limit: Option[Maxlimit])
case class Locode (country: String, port: String)
case class Polygon (lat: Option[Double], lon: Option[Double])
case class Maxlimit (width: Option[Double], length: Option[Double])

object JsonFormats {

  import play.api.libs.json.Json

  // Generates Writes and Reads for models
  implicit val locodeFormat = Json.format[Locode]
  implicit val polygonFormat = Json.format[Polygon]
  implicit val maxlimitFormat = Json.format[Maxlimit]
  implicit val portFormat = Json.format[Port]
}
