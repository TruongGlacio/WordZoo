import com.android.build.api.dsl.CommonExtension
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        if (name == "applovin_max") {
            extensions.findByName("android")?.let { androidExtension ->
                val compileSdkProperty = androidExtension.javaClass
                    .methods
                    .firstOrNull { it.name == "setCompileSdk" }

                compileSdkProperty?.invoke(androidExtension, 37)
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}
/**
 * Override compileSdk for Android subprojects.
 *
 * This also applies to the applovin_max plugin.
 */

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
