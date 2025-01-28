package com.olivier.ettlin.geomessage

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.olivier.ettlin.geomessage/background"

    // Coroutine Scope pour gérer les coroutines en arrière-plan
    private val scope = CoroutineScope(Dispatchers.Default)

    // Job de la coroutine (pour garantir une seule tâche active)
    private var job: Job? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configuration du canal pour communiquer avec Flutter
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startBackgroundProcess" -> {
                    startBackgroundProcess(result)
                }
                "stopBackgroundProcess" -> {
                    stopBackgroundProcess()
                    result.success("Process stopped")
                }
                else -> result.notImplemented()
            }
        }
    }

    // Fonction pour démarrer le processus en tâche de fond
    private fun startBackgroundProcess(result: MethodChannel.Result) {
        // Vérifie si un processus est déjà actif
        if (job?.isActive == true) {
            result.success("Un processus est déjà en cours d'exécution.")
            return
        }

        // Lancement du processus
        job = scope.launch {
            try {
                while (isActive) { // La coroutine reste active tant qu'elle n'est pas annulée
                    println("Tâche exécutée en arrière-plan à : ${System.currentTimeMillis()}")
                    delay(10000L) // Répéter toutes les 10 secondes
                }
            } catch (e: CancellationException) {
                println("Le processus a été annulé.")
            }
        }
        result.success("Processus démarré.")
    }

    // Fonction pour arrêter le processus
    private fun stopBackgroundProcess() {
        if (job?.isActive == true) {
            job?.cancel() // Annuler la coroutine
            job = null // Réinitialiser le job pour éviter d'y accéder par erreur
            println("Tâche arrêtée.")
        } else {
            println("Aucun processus actif à arrêter.")
        }
    }

    // Assurer un nettoyage propre lorsque l'activité est détruite
    override fun onDestroy() {
        super.onDestroy()
        stopBackgroundProcess() // Arrêter le processus s'il est actif
    }
}
