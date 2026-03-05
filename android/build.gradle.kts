// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.4")
    }
}

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

// Workaround for Isar 3.1.0+1 compatibility with AGP 8+ (Namespace Error)
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            if (android.namespace == null) {
                android.namespace = project.group.toString()
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Suppress Kotlin deprecation warnings in external Flutter plugin packages
// (e.g., nfc_manager 3.5.0 uses String.toLowerCase which is deprecated in Kotlin 2.1)
subprojects {
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        if (project.name != "app") {
            kotlinOptions {
                freeCompilerArgs += listOf("-Xsuppress-version-warnings")
                @Suppress("DEPRECATION")
                allWarningsAsErrors = false
                languageVersion = "1.9"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
