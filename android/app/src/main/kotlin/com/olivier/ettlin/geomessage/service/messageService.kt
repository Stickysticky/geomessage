package com.olivier.ettlin.geomessage.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import com.olivier.ettlin.geomessage.model.Message
import com.olivier.ettlin.geomessage.service.LocalisationService
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import com.olivier.ettlin.geomessage.service.DatabaseService
import kotlinx.coroutines.Job // Ajoutez cet import pour Job

class MessageService(private val context: Context) {

    private val flutterEngine = FlutterEngine(context) // Créez un FlutterEngine
    private val backgroundChannel = MethodChannel(flutterEngine.dartExecutor, "com.olivier.ettlin.geomessage/background") // Utilisez dartExecutor pour le BinaryMessenger
    private val db = DatabaseService(context)
    private val localisationService = LocalisationService(context)

    private val channelId = "message_service_channel" // ID du canal de notification

    // Créer un canal de notification pour les versions Android >= Oreo (API 26)
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId, // ID du canal
                "Message Service", // Nom du canal
                NotificationManager.IMPORTANCE_DEFAULT // Importance du canal
            ).apply {
                description = "Notifications pour les messages envoyés"
            }

            // Créez le canal si il n'existe pas déjà
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    // Méthode pour gérer les messages sans date
    fun handleMessagesWithoutDates(job: Job?) {
        // Créez le canal de notification si nécessaire
        createNotificationChannel()

        if (localisationService.isLocationServiceEnabled()) {
            val messages = db.getMessagesWithoutDate() // Assurez-vous que cette méthode retourne une liste de messages
            for (message in messages) {
                Log.d("MessageService", "Libellé du message: ${message.libelle}")

                localisationService.checkCurrentLocationInRadius(message) { inRadius ->
                    if (inRadius) {
                        Log.d("MessageService", "Message dans le rayon")

                        // Envoyer la notification
                        sendNotification(message)

                        // Suppression du message après avoir envoyé la notification
                        db.deleteMessage(message.id!!) // Suppression du message
                    } else {
                        Log.d("MessageService", "Message hors du rayon")
                    }
                }
            }

            // Vérifier si la liste des messages est vide et annuler la tâche si nécessaire
            if (messages.isEmpty()) {
                job?.takeIf { it.isActive }?.cancel() // Annuler la coroutine
                println("Tâche arrêtée.")
            }
        }
    }

    // Méthode pour envoyer la notification
    private fun sendNotification(message: Message) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Créer la notification
        val notification: Notification = Notification.Builder(context, channelId)
            .setContentTitle("Message envoyé")
            .setContentText("Le message ${message.libelle} a été envoyé au ${message.phoneNumber}")
            .setSmallIcon(android.R.drawable.ic_dialog_info) // Icône par défaut
            .setPriority(Notification.PRIORITY_HIGH)  // Priorité élevée pour afficher immédiatement
            .build()

        // Afficher la notification
        notificationManager.notify(message.id!!, notification)

        Log.d("MessageService", "Notification envoyée pour ${message.libelle} à ${message.phoneNumber}")
    }
}
