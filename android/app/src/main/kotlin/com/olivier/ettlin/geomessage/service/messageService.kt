package com.olivier.ettlin.geomessage.service

import android.content.Context
import android.util.Log
import com.olivier.ettlin.geomessage.model.Message
import com.olivier.ettlin.geomessage.service.LocalisationService
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import com.olivier.ettlin.geomessage.service.DatabaseService

class MessageService(private val context: Context) {

    private val flutterEngine = FlutterEngine(context) // Créez un FlutterEngine
    private val backgroundChannel = MethodChannel(flutterEngine.dartExecutor, "com.olivier.ettlin.geomessage/background") // Utilisez dartExecutor pour le BinaryMessenger
    private val db = DatabaseService(context)
    private val localisationService = LocalisationService(context)

    // Méthode pour gérer les messages sans date
    fun handleMessagesWithoutDates() {
        if(localisationService.isLocationServiceEnabled()){
            val messages = db.getMessagesWithoutDate() // Assurez-vous que cette méthode retourne une liste de messages
            for (message in messages) {
                Log.d("MessageService", "Libellé du message: ${message.libelle}")
                localisationService.checkCurrentLocationInRadius(message) { inRadius ->
                    if (inRadius) {
                        Log.d("MessageService", "Message dans le rayon")
                    } else {
                        Log.d("MessageService", "Message hors du rayon")
                    }
                }
            }
        }
    }

    // Méthode pour démarrer le processus en arrière-plan
    /*fun startBackgroundProcess() {
        try {
            backgroundChannel.invokeMethod("startBackgroundProcess", null)
        } catch (e: Exception) {
            Log.e("MessageService", "Erreur lors de l'appel de startBackgroundProcess: ${e.message}")
        }
    }*/
}
