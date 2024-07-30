import Dependencies.*

ThisBuild / version := "0.1.0-SNAPSHOT"

ThisBuild / scalaVersion := "2.13.14"



lazy val apiSpecification = project
  .in(file("api-specification"))
  .settings(name := "coverflex-service-api")
  .settings(libraryDependencies ++= http4s)
  .settings(
    GuardrailServerGenerator.generateFor(
      swaggerResourceFile = "apiv1.yaml",
      generatedPkgName = "it.adami.interview.coverflex.service.specification",
      modules = "http4s" :: "circe" :: Nil
    )
  )

lazy val service = project
  .in(file("service"))
  .settings(name := "coverflex-service")
  .settings(libraryDependencies ++= http4s ++ database ++ log4Cats ++ munit ++ pureConfig ++ Seq(catsEffect, flyway))
  .dependsOn(apiSpecification)

lazy val root = (project in file("."))
  .settings(
    name := "coverflex-backend",
    organizationName := "it.adami"
  )
  .settings(
    run := {
      (run in service in Compile).evaluated // Enables "sbt run" on the root project
    }
  )
  .aggregate(apiSpecification, service)



ThisBuild / run / fork := true



