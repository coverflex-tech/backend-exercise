package it.adami.interview.coverflex.config

import pureconfig._
import pureconfig.error.CannotConvert
import com.comcast.ip4s.{Host, Port}

object ConfigImplicits {
  implicit val hostReader: ConfigReader[Host] = ConfigReader[String].emap { str =>
    Host.fromString(str).toRight(CannotConvert(str, "Host", "Invalid host format"))
  }

  implicit val portReader: ConfigReader[Port] = ConfigReader[Int].emap { int =>
    Port.fromInt(int).toRight(CannotConvert(int.toString, "Port", "Invalid port format"))
  }
}