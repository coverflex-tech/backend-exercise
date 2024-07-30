package it.adami.interview.coverflex.db

import cats.effect.IO
import it.adami.interview.coverflex.config.{DatabaseConfig, FlywayConfig}
import it.adami.interview.coverflex.db.FlywayMigration.FlywayResult
import org.flywaydb.core.Flyway
import org.flywaydb.core.api.configuration.FluentConfiguration


sealed abstract class FlywayMigration {

  protected val flyway: Flyway

  def migrate: IO[FlywayResult] =
    IO.interruptible(flyway.migrate()).map(result => FlywayResult(result.migrationsExecuted, result.success))
}

object FlywayMigration {
  case class FlywayResult(migrationsExecuted: Int, success: Boolean)

  def create(flywayConfig: FlywayConfig, psqlConfig: DatabaseConfig): IO[FlywayMigration] =
    IO(new FlywayMigration {
      override protected val flyway: Flyway =
        new FluentConfiguration()
          .connectRetries(flywayConfig.connectRetries)
          .locations(flywayConfig.locations)
          .sqlMigrationPrefix(flywayConfig.sqlMigrationPrefix)
          .repeatableSqlMigrationPrefix(flywayConfig.repeatableSqlMigrationPrefix)
          .sqlMigrationSeparator(flywayConfig.sqlMigrationSeparator)
          .sqlMigrationSuffixes(flywayConfig.sqlMigrationSuffixes)
          .encoding(flywayConfig.encoding)
          .baselineOnMigrate(flywayConfig.baselineOnMigration)
          .baselineVersion(flywayConfig.baselineVersion)
          .dataSource(psqlConfig.url, psqlConfig.username, psqlConfig.password)
          .load()
    })

}
