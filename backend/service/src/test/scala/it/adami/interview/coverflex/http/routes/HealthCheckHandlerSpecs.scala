package it.adami.interview.coverflex.http.routes

import cats.effect.IO
import it.adami.interview.coverflex.service.specification.healthCheck.HealthCheckResource
import munit.CatsEffectSuite
import org.http4s.{Method, Request, Status}
import org.http4s.implicits._

class HealthCheckHandlerSpecs extends CatsEffectSuite {



  private val healthCheckHandler = HealthCheckHandler
  private val application = new HealthCheckResource[IO].routes(healthCheckHandler).orNotFound

  test("HealthCheckHandler should return 204 status when the application is working") {
    for {
      response <- application.run(Request[IO](Method.GET, uri"/api/health"))
      _ = assertEquals(response.status, Status.NoContent)
    } yield ()
    }


}
