package it.adami.interview.coverflex.http.routes

import cats.effect.IO
import it.adami.interview.coverflex.service.specification.definitions.Entity
import it.adami.interview.coverflex.service.specification.entity.EntityResource
import it.adami.interview.coverflex.service.specification.definitions.BadRequest

//Just a simple example
object EntityHandler extends it.adami.interview.coverflex.service.specification.entity.EntityHandler[IO] {

  override def createEntity(respond: EntityResource.CreateEntityResponse.type)(body: Entity): IO[EntityResource.CreateEntityResponse] = body match {
    case Entity(id, _) if id > 0 => IO.pure(respond.Created(body))
    case _ => IO.pure(respond.BadRequest(BadRequest("Invalid entity")))
  }
}
