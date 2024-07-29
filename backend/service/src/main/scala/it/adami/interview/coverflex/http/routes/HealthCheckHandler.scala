package it.adami.interview.coverflex.http.routes

import cats.effect._
import org.typelevel.log4cats.{LoggerFactory, SelfAwareStructuredLogger}
import it.adami.interview.coverflex.service.specification.healthCheck.HealthCheckResource
import org.typelevel.log4cats.slf4j._

object HealthCheckHandler extends it.adami.interview.coverflex.service.specification.healthCheck.HealthCheckHandler[IO] {

  private val logger: SelfAwareStructuredLogger[IO] = LoggerFactory[IO].getLogger


  override def healthCheck(respond: HealthCheckResource.HealthCheckResponse.type)(): IO[HealthCheckResource.HealthCheckResponse] =
    for {
      _ <- logger.debug("I'm all good, thank you")
      result = respond.NoContent
    } yield result
}
