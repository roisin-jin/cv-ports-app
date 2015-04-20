package models

/**
 * Created by roisin_jin on 4/20/15.
 */
case class ISOCountry(code: String, name: String)

object ISOCountryFormats {

  import play.api.libs.json.Json

  implicit val countryFormat = Json.format[ISOCountry]
}
