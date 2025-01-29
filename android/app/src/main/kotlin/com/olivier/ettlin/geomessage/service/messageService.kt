package com.olivier.ettlin.geomessage.service

import android.content.Context
import android.util.Log
import com.olivier.ettlin.geomessage.model.Message
import com.olivier.ettlin.geomessage.service.LocalisationService
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import com.olivier.ettlin.geomessage.service.DatabaseService
import kotlinx.coroutines.Job

class MessageService(private val context: Context) {

    private val flutterEngine = FlutterEngine(context) // Créez un FlutterEngine
    private val backgroundChannel = MethodChannel(flutterEngine.dartExecutor, "com.olivier.ettlin.geomessage/background") // Utilisez dartExecutor pour le BinaryMessenger
    private val db = DatabaseService(context)
    private val localisationService = LocalisationService(context)

    // Méthode pour gérer les messages sans date
    fun handleMessagesWithoutDates(job: Job?) {
        if (localisationService.isLocationServiceEnabled()) {
            val messages = db.getMessagesWithoutDate() // Assurez-vous que cette méthode retourne une liste de messages
            if (messages.isEmpty()) {
                if (job?.isActive == true) {
                    job?.cancel() // Annuler la coroutine
                    println("Tâche arrêtée car aucun message n'est disponible.")
                }
            } else {
                // Si des messages sont présents, on les traite
                for (message in messages) {
                    Log.d("MessageService", "Libellé du message: ${message.libelle}")
                    localisationService.checkCurrentLocationInRadius(message) { inRadius ->
                        if (inRadius) {
                            Log.d("MessageService", "Message dans le rayon")
                            db.deleteMessage(message.id!!) // Suppression du message
                        } else {
                            Log.d("MessageService", "Message hors du rayon")
                        }
                    }
                }
            }
        }
    }
}
