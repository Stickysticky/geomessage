package com.olivier.ettlin.geomessage.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log

class MyForegroundService : Service() {

    private val CHANNEL_ID = "ForegroundServiceChannel"
    private var isRunning = true

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()

        // Créer une notification pour le service en premier plan
        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Service en cours")
            .setContentText("Votre tâche s'exécute en arrière-plan.")
            .setSmallIcon(android.R.drawable.ic_dialog_info) // Utilisez une icône existante
            .build()

        // Démarrer le service en premier plan
        startForeground(1, notification)

        // Exécuter une tâche périodique
        Thread {
            while (isRunning) {
                try {
                    Log.d("ForegroundService", "Tâche exécutée !")
                    Thread.sleep(5000) // Attendre 5 secondes
                } catch (e: InterruptedException) {
                    e.printStackTrace()
                }
            }
        }.start()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false // Arrêter la boucle d'exécution
        Log.d("ForegroundService", "Service arrêté.")
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(serviceChannel)
        }
    }
}