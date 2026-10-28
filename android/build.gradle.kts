allprojects {
    repositories {
        google()
        mavenCentral()
        listOf("spandan_ecg_android_sdk", "spandan_ecg_android_sdk_ui").forEach { repo ->
            maven {
                url = uri("https://maven.pkg.github.com/sunfox-technologies/$repo")
                credentials {
                    username = providers.gradleProperty("SPANDAN_GH_USER").orNull
                    password = providers.gradleProperty("SPANDAN_GH_TOKEN").orNull
                }
                content { includeGroupByRegex("in\\.sunfox.*") }
            }
        }
        maven { url = uri("https://jitpack.io") }
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
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
