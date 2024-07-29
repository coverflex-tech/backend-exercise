package it.adami.interview.coverflex.config

import cats.effect.IO
import com.comcast.ip4s.{Host, Port}
import pureconfig._
import pureconfig.generic.auto._
import pureconfig.module.catseffect.syntax._
import it.adami.interview.coverflex.config.ConfigImplicits._

final case class ServerConfig(host: Host, port: Port)

final case class AppConfig(server: ServerConfig)

object AppConfig {
  def load: IO[AppConfig] =
    ConfigSource.default.loadF[IO, AppConfig]()

}