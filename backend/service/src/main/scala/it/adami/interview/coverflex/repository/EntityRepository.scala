package it.adami.interview.coverflex.repository

import cats.effect.IO
import doobie.util.transactor.Transactor
import it.adami.interview.coverflex.domain.Entity
import doobie._
import doobie.implicits._

trait EntityRepository {

  def createEntity(entity: Entity): IO[Unit]

  def getEntityById(id: Long): IO[Entity]

  def getAll: IO[Seq[Entity]]

}

final class DoobieEntityRepository(xa: Transactor[IO]) extends EntityRepository {

  override def createEntity(entity: Entity): IO[Unit] =
    insertEntity(entity).withUniqueGeneratedKeys("id").transact(xa)


  override def getEntityById(id: Long): IO[Entity] =
    getEntity(id).unique.transact(xa)
  private def insertEntity(entity: Entity): Update0 = sql"""
    INSERT INTO entity (id, name, value) VALUES (${entity.id}, ${entity.name}, ${entity.value})
  """.update

  private def getEntity(id: Long) =
    sql"""
      SELECT id, name, value
      FROM entity
      WHERE id = $id
       """
      .query[Entity]

  override def getAll: IO[Seq[Entity]] =
    sql"""
         SELECT id, name, value
         FROM entity
       """.query[Entity]
      .stream
      .compile
      .toList
      .transact(xa)
}
