package it.adami.interview.coverflex.http.routes

import cats.effect.IO
import it.adami.interview.coverflex.service.specification.entity.EntityResource
import it.adami.interview.coverflex.service.specification.healthCheck.HealthCheckResource
import munit.CatsEffectSuite
import org.http4s.implicits.http4sLiteralsSyntax
import org.http4s.{Method, Request, Status}

class EntityHandlerSpecs extends CatsEffectSuite {

  private val entityHandler = EntityHandler
  private val application = new EntityResource[IO].routes(entityHandler).orNotFound

  test("Entity should return 201 status when the entity is valid") {

    val request = Request[IO](Method.POST, uri"/api/entity").withEntity("""{"id":1,"name":"test"}""")
    for {
      response <- application.run(request)
      _ = assertEquals(response.status, Status.Created)
      _ = assertEquals(response.as[String].unsafeRunSync, """{"id":1,"name":"test"}""")
    } yield ()
  }

  test("Entity should return 4044 status when the entity is invalid") {

    val request = Request[IO](Method.POST, uri"/api/entity").withEntity("""{"id":-1,"name":"test"}""")
    for {
      response <- application.run(request)
      _ = assertEquals(response.status, Status.BadRequest)
      _ = assertEquals(response.as[String].unsafeRunSync, """{"message":"Invalid entity","error":"BadRequest"}""".stripMargin)
    } yield ()
  }

}
