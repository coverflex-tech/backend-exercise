import sbt.*

object Dependencies {

  val http4s =
    Seq(
      "org.http4s" %% "http4s-ember-client" % Versions.Http4sVersion,
      "org.http4s" %% "http4s-ember-server" % Versions.Http4sVersion,
      "org.http4s" %% "http4s-circe" % Versions.Http4sVersion,
      "org.http4s" %% "http4s-dsl" % Versions.Http4sVersion,
      "io.circe" %% "circe-generic" % Versions.CirceVersion,
      "io.circe" %% "circe-parser" % Versions.CirceVersion
    )

  val database =
    Seq(
      "org.tpolecat" %% "doobie-core" % Versions.Doobie,
      "org.tpolecat" %% "doobie-hikari" % Versions.Doobie, // HikariCP transactor.
      "org.tpolecat" %% "doobie-postgres" % Versions.Doobie,
      "org.postgresql" % "postgresql" % Versions.JdbcPostgresql
    )

  val flyway = "org.flywaydb" % "flyway-core" % "9.19.1"


  val catsEffect = "org.typelevel" %% "cats-effect" % Versions.CatsEffectVersion

  val pureConfig = Seq(
    "com.github.pureconfig" %% "pureconfig" % Versions.PureConfigVersion,
    "com.github.pureconfig" %% "pureconfig-cats-effect" % Versions.PureConfigVersion
  )

  val log4Cats =
    Seq(
      "org.typelevel" %% "log4cats-core" % Versions.Log4CatsVersion,
      "org.typelevel" %% "log4cats-slf4j" % Versions.Log4CatsVersion,
      "ch.qos.logback" % "logback-classic" % "1.2.10"
    )

  val munit = Seq("org.typelevel" %% "munit-cats-effect" % Versions.MunitCatsEffectVersion % Test)

}

object Versions {
  val Http4sVersion = "0.23.27"
  val CirceVersion = "0.14.8"
  val CatsEffectVersion = "3.5.4"
  val Doobie = "1.0.0-RC5"
  val Fly4s = "0.0.20"
  val JdbcPostgresql = "42.6.1"
  val PureConfigVersion = "0.17.7"
  val Log4CatsVersion = "2.6.0"
  val MunitCatsEffectVersion = "2.0.0"
}
