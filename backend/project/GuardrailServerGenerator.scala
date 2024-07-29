import dev.guardrail.sbt.GuardrailPlugin.autoImport.ScalaServer
import dev.guardrail.sbt.Keys.*
import sbt.*
import sbt.Keys.*

object GuardrailServerGenerator {

  def generateFor(
                   swaggerResourceFile: String,
                   generatedPkgName: String,
                   modules: List[String] = List.empty,
                 ): Seq[Def.Setting[_]] = Seq(
    // Guardrail requirement
    scalacOptions ++= Seq("-Ymacro-annotations"),
    // silence warns in generated source code
    scalacOptions += "-Wconf:src=src_managed/.*:silent",
    Compile / guardrailTasks := List(
      ScalaServer(
        specPath = (Compile / resourceDirectory).value / swaggerResourceFile,
        pkg = generatedPkgName,
        tracing = false,
        modules = modules
      )
    )
  )
}