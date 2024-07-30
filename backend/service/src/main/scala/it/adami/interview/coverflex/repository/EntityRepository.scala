package it.adami.interview.coverflex.repository

import cats.effect.IO
import doobie.util.transactor.Transactor
import it.adami.interview.coverflex.domain.Entity
import doobie._
import doobie.implicits._

trait EntityRepository {

  def createEntity(entity: Entity): IO[Unit]

}

final class DoobieEntityRepository(xa: Transactor[IO]) extends EntityRepository {

  override def createEntity(entity: Entity): IO[Unit] =
    insertEntity(entity).withUniqueGeneratedKeys("id").transact(xa)
  private def insertEntity(entity: Entity): Update0 = sql"""
    INSERT INTO entity (id, name) VALUES (${entity.id}, ${entity.name})
  """.update
}
