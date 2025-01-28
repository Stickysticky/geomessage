package com.olivier.ettlin.geomessage

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.olivier.ettlin.geomessage/background" // Vérifiez que le nom du canal correspond

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configure un listener de canal pour Flutter
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startBackgroundTask") { // Vérifiez que le nom de la méthode correspond
                startBackgroundProcess()
                result.success("Process started")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startBackgroundProcess() {
        // Créez un travail périodique avec WorkManager
        val workRequest = PeriodicWorkRequestBuilder<BackgroundWorker>(10, TimeUnit.SECONDS)
            .build()

        // Enfilez le travail avec WorkManager
        WorkManager.getInstance(this).enqueue(workRequest)
    }
}

// Le Worker qui contient la tâche à exécuter
class BackgroundWorker(context: android.content.Context, workerParams: androidx.work.WorkerParameters) : androidx.work.Worker(context, workerParams) {
    override fun doWork(): Result {
        // Code que vous souhaitez exécuter en arrière-plan
        println("Tâche exécutée en arrière-plan !")
        return Result.success()
    }
}
