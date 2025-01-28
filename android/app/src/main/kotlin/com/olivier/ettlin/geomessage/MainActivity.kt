package com.olivier.ettlin.geomessage

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.olivier.ettlin.geomessage/background" // Vérifiez que le nom du canal correspond

    // Coroutine Scope pour gérer le travail en arrière-plan
    private val scope = CoroutineScope(Dispatchers.Default)

    // Drapeau pour contrôler la pause/reprise
    private var isPaused = false

    // Job de la coroutine
    private var job: Job? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configuration du handler
        val mainHandler = Handler(Looper.getMainLooper())

        // Configure un listener de canal pour Flutter
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startBackgroundProcess" -> {
                    startBackgroundProcess()
                    result.success("Process started")
                }
                "pauseBackgroundProcess" -> {
                    pauseBackgroundProcess()
                    result.success("Process paused")
                }
                "resumeBackgroundProcess" -> {
                    resumeBackgroundProcess()
                    result.success("Process resumed")
                }
                else -> result.notImplemented()
            }
        }
    }

    // Fonction pour démarrer le processus en tâche de fond
    private fun startBackgroundProcess() {
        job = scope.launch {
            while (isActive) { // La coroutine reste active tant qu'elle n'est pas annulée
                if (!isPaused) {
                    // Processus en arrière-plan (à répéter toutes les 10 secondes)
                    println("Tâche exécutée en arrière-plan à : ${System.currentTimeMillis()}")
                } else {
                    println("Processus en pause...")
                }
                delay(10000L) // Attendre 10 secondes avant de répéter
            }
        }
    }

    // Fonction pour mettre en pause le processus
    private fun pauseBackgroundProcess() {
        isPaused = true
    }

    // Fonction pour reprendre le processus
    private fun resumeBackgroundProcess() {
        isPaused = false
    }

    // Annuler le job quand l'activité est détruite
    override fun onDestroy() {
        super.onDestroy()
        job?.cancel() // Annule la coroutine si l'activité est détruite
    }
}
