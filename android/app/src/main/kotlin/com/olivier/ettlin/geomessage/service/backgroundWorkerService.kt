package com.olivier.ettlin.geomessage.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.os.Handler
import android.os.Looper
import com.olivier.ettlin.geomessage.service.MessageService
import kotlinx.coroutines.*

class BackgroundWorkerService : Service() {

    private val CHANNEL = "com.olivier.ettlin.geomessage/background"
    private var job: Job? = null
    private val scope = CoroutineScope(Dispatchers.Default)
    private lateinit var messageService: MessageService

    override fun onCreate() {
        super.onCreate()
        // Initialiser MessageService avec le contexte du service
        messageService = MessageService(applicationContext) // Passer le contexte à MessageService
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }


    // Démarre le processus en tâche de fond
    fun startBackgroundProcess() {
        if (job?.isActive == true) {
            println("Un processus est déjà en cours d'exécution.")
            return
        }

        // Initialisation de messageService si nécessaire
        if (!::messageService.isInitialized) {
            messageService = MessageService(applicationContext) // Initialisation à la demande
        }

        job = scope.launch {
            try {
                while (isActive) {
                    messageService.handleMessagesWithoutDates()
                    println("Tâche exécutée en arrière-plan à : ${System.currentTimeMillis()}")
                    delay(10000L)
                }
            } catch (e: CancellationException) {
                println("Le processus a été annulé.")
            }
        }
    }


    // Fonction pour appeler la méthode Flutter
    private fun callFlutterFunction() {
        // Appeler Flutter via un MethodChannel si nécessaire
    }

    // Arrête le processus
    fun stopBackgroundProcess() {
        if (job?.isActive == true) {
            job?.cancel() // Annuler la coroutine
            job = null // Réinitialiser le job pour éviter d'y accéder par erreur
            println("Tâche arrêtée.")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopBackgroundProcess() // Arrêter le processus lorsque le service est détruit
    }
}
