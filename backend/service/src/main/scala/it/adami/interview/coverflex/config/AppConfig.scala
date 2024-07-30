package it.adami.interview.coverflex.config

import cats.effect.IO
import com.comcast.ip4s.{Host, Port}
import pureconfig._
import pureconfig.generic.auto._
import pureconfig.module.catseffect.syntax._
import it.adami.interview.coverflex.config.ConfigImplicits._

final case class ServerConfig(host: Host, port: Port)

final case class DatabaseConfig(host: String, port: Int, username: String, password: String, db: String) {
  lazy val driver: String = "org.postgresql.Driver"
  lazy val url: String = s"jdbc:postgresql://$host:$port/$db"

}

final case class FlywayConfig(
                         connectRetries: Int,
                         locations: String,
                         sqlMigrationPrefix: String,
                         repeatableSqlMigrationPrefix: String,
                         sqlMigrationSeparator: String,
                         sqlMigrationSuffixes: String,
                         encoding: String,
                         baselineVersion: String,
                         baselineOnMigration: Boolean
                       )

final case class AppConfig(server: ServerConfig, database: DatabaseConfig, flyway: FlywayConfig)

object AppConfig {
  def load: IO[AppConfig] =
    ConfigSource.default.loadF[IO, AppConfig]()
}