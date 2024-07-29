package it.adami.interview.coverflex

import cats.effect.{IO, Resource, ResourceApp}
import cats.implicits._
import it.adami.interview.coverflex.config.AppConfig
import it.adami.interview.coverflex.http.routes.{EntityHandler, HealthCheckHandler}
import it.adami.interview.coverflex.service.specification.entity.EntityResource
import it.adami.interview.coverflex.service.specification.healthCheck.HealthCheckResource
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.ember.server.EmberServerBuilder
import org.typelevel.log4cats.{LoggerFactory, SelfAwareStructuredLogger}
import org.typelevel.log4cats.slf4j._

object Main extends ResourceApp.Forever {

  private val logger: SelfAwareStructuredLogger[IO] = LoggerFactory[IO].getLogger

  override def run(args: List[String]): Resource[IO, Unit] =
    for {
       _ <- logger.info("Starting application...").toResource
      config <- AppConfig.load.toResource
      client <- EmberClientBuilder.default[IO].build
      healthCheckRoutes = new HealthCheckResource[IO]().routes(HealthCheckHandler)
      entityRoutes = new EntityResource[IO]().routes(EntityHandler)
      allRoutes = healthCheckRoutes <+> entityRoutes <+> entityRoutes
      _ <- EmberServerBuilder
        .default[IO]
        .withHost(config.server.host)
        .withPort(config.server.port)
        .withHttpApp(allRoutes.orNotFound)
        .build
        .useForever
        .toResource

    } yield ()
}
