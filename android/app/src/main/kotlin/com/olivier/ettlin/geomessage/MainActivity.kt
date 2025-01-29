package com.olivier.ettlin.geomessage

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import android.content.Context
import android.location.LocationManager
import com.olivier.ettlin.geomessage.service.MessageService

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



    private fun isGPSEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }


    // Fonction pour démarrer le processus en tâche de fond
    private fun startBackgroundProcess(result: MethodChannel.Result) {
        // Vérifie si un processus est déjà actif
        if (job?.isActive == true) {
            result.success("Un processus est déjà en cours d'exécution.")
            return
        }

        val messageService = MessageService(applicationContext)

        // Lancement du processus
        job = scope.launch {
            try {
                while (isActive) { // La coroutine reste active tant qu'elle n'est pas annulée

                    // Appel de la fonction Flutter
                    if (isGPSEnabled()) {
                        messageService.handleMessagesWithoutDates(job)
                        println("Tâche exécutée en arrière-plan à : ${System.currentTimeMillis()}")
                    }

                    delay(5000L) // Répéter toutes les 5 secondes
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
