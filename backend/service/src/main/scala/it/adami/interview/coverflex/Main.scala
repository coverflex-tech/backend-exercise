package it.adami.interview.coverflex

import cats.effect.{IO, Resource, ResourceApp}
import cats.implicits._
import it.adami.interview.coverflex.config.AppConfig
import it.adami.interview.coverflex.db.{DoobieDbAccess, FlywayMigration}
import it.adami.interview.coverflex.domain.Entity
import it.adami.interview.coverflex.http.routes.{DocumentationHandler, EntityHandler, HealthCheckHandler}
import it.adami.interview.coverflex.repository.DoobieEntityRepository
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
      flyway <- FlywayMigration.create(config.flyway, config.database).toResource
      migrationResult <- flyway.migrate.toResource
       _ <- logger.info(s"Applied migration, result: ${migrationResult.success}").toResource

      transactor <- DoobieDbAccess.transactor(config.database)
      entityRepository = new DoobieEntityRepository(transactor)
      _ <- entityRepository.createEntity(Entity(1, "test")).toResource
      healthCheckRoutes = new HealthCheckResource[IO]().routes(HealthCheckHandler)
      entityRoutes = new EntityResource[IO]().routes(EntityHandler)
      documentRoutes = DocumentationHandler.routes
      allRoutes = healthCheckRoutes <+> entityRoutes <+> documentRoutes
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
