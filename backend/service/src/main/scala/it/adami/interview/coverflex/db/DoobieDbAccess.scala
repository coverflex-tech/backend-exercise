package it.adami.interview.coverflex.db

import cats.effect._
import doobie.hikari._
import com.zaxxer.hikari.HikariConfig
import doobie.{ExecutionContexts, Transactor}
import doobie.hikari.HikariTransactor
import it.adami.interview.coverflex.config.DatabaseConfig

object DoobieDbAccess {
  def transactor(config: DatabaseConfig): Resource[IO, Transactor[IO]] = {
    for {
      hikariConfig <- Resource.pure {
        val hikariConfig = new HikariConfig()
        hikariConfig.setDriverClassName(config.driver)
        hikariConfig.setJdbcUrl(config.url)
        hikariConfig.setUsername(config.username)
        hikariConfig.setPassword(config.password)
        hikariConfig.setMaximumPoolSize(10) //just an example
        hikariConfig
      }
      transactor <- HikariTransactor.fromHikariConfig[IO](hikariConfig)
    } yield transactor
  }


}
