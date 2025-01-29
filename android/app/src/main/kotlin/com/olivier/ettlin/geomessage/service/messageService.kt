package com.olivier.ettlin.geomessage.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.util.Log
import com.olivier.ettlin.geomessage.model.Message
import com.olivier.ettlin.geomessage.service.LocalisationService
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import com.olivier.ettlin.geomessage.service.DatabaseService
import kotlinx.coroutines.Job
import android.telephony.SmsManager


class MessageService(private val context: Context) {

    private val flutterEngine = FlutterEngine(context)
    private val backgroundChannel = MethodChannel(flutterEngine.dartExecutor, "com.olivier.ettlin.geomessage/background")
    private val db = DatabaseService(context)
    private val localisationService = LocalisationService(context)

    private val channelId = "message_service_channel"

    // Créer un canal de notification avec son
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val soundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            val channel = NotificationChannel(
                channelId,
                "Message Service",
                NotificationManager.IMPORTANCE_HIGH // IMPORTANCE_HIGH pour inclure le son
            ).apply {
                description = "Notifications pour les messages envoyés"
                setSound(soundUri, null) // Ajout du son
                enableVibration(true) // Activer la vibration
            }

            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    // Méthode pour gérer les messages sans date
    fun handleMessagesWithoutDates(job: Job?) {
        createNotificationChannel()

        if (localisationService.isLocationServiceEnabled()) {
            val messages = db.getMessagesWithoutDate()
            for (message in messages) {
                Log.d("MessageService", "Libellé du message: ${message.libelle}")

                localisationService.checkCurrentLocationInRadius(message) { inRadius ->
                    if (inRadius) {
                        Log.d("MessageService", "Message dans le rayon")

                        sendSms(message.phoneNumber, message.message)
                        sendNotification(message)

                        db.updateMessageWithCurrentDate(message);
                    } else {
                        Log.d("MessageService", "Message hors du rayon")
                    }
                }
            }

            if (messages.isEmpty()) {
                job?.takeIf { it.isActive }?.cancel()
                println("Tâche arrêtée.")
            }
        }
    }

    private fun sendSms(phoneNumber: String, messageText: String) {
        val smsManager = SmsManager.getDefault()
        try {
            smsManager.sendTextMessage(phoneNumber, null, messageText, null, null)
            Log.d("MessageService", "SMS envoyé à $phoneNumber: $messageText")
        } catch (e: Exception) {
            Log.e("MessageService", "Erreur lors de l'envoi du SMS: ${e.message}")
        }
    }

    private fun sendNotification(message: Message) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val soundUri: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

        val notification: Notification = Notification.Builder(context, channelId)
            .setContentTitle("Message envoyé")
            .setContentText("Le message ${message.libelle} a été envoyé au ${message.phoneNumber}")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(Notification.PRIORITY_HIGH)
            .setSound(soundUri)
            .setVibrate(longArrayOf(100, 200, 300, 400, 500))
            .build()

        notificationManager.notify(message.id!!, notification)

        Log.d("MessageService", "Notification envoyée avec son pour ${message.libelle} à ${message.phoneNumber}")
    }
}
