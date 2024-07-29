package it.adami.interview.coverflex.http.routes

import cats.effect.IO
import org.http4s.{HttpRoutes, StaticFile}
import org.http4s.dsl.io._

object DocumentationHandler {

  def routes = HttpRoutes.of[IO] {
    case request @ GET -> Root / "api-docs" =>
      StaticFile
        .fromResource("/api-docs/index.html", Some(request))
        .getOrElseF(NotFound())
    case request @ GET -> Root / "api-docs" / "swagger.yaml" =>
      StaticFile
        .fromResource("/apiv1.yaml", Some(request))
        .getOrElseF(NotFound())
  }

}
