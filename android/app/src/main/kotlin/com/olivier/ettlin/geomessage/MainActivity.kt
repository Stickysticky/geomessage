package com.olivier.ettlin.geomessage

import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import com.olivier.ettlin.geomessage.service.BackgroundWorkerService

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.olivier.ettlin.geomessage/background"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Configurer le canal pour communiquer avec Flutter
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startBackgroundProcess" -> {
                    startBackgroundProcess(result)
                }
                "stopBackgroundProcess" -> {
                    stopBackgroundProcess(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startBackgroundProcess(result: MethodChannel.Result) {

        // Créez un Intent pour démarrer le service BackgroundWorkerService
        val serviceIntent = Intent(this, BackgroundWorkerService::class.java)
        startService(serviceIntent)
/*
        // Obtient l'instance du service en cours d'exécution pour démarrer le processus
        val backgroundWorkerService = BackgroundWorkerService()
        backgroundWorkerService.startBackgroundProcess()*/

        // Envoie un résultat de succès à Flutter
        result.success("Processus démarré.")
    }


    // Arrête le processus en arrière-plan
    private fun stopBackgroundProcess(result: MethodChannel.Result) {
        // Crée un Intent pour arrêter le service BackgroundWorkerService
        val serviceIntent = Intent(this, BackgroundWorkerService::class.java)
        stopService(serviceIntent)

        // Arrête le processus dans BackgroundWorkerService
        BackgroundWorkerService().stopBackgroundProcess()

        // Envoie un résultat de succès à Flutter
        result.success("Processus arrêté.")
    }

    // Assurer un nettoyage propre lorsque l'activité est détruite
    override fun onDestroy() {
        super.onDestroy()
        // Assurez-vous d'appeler stopBackgroundProcess dans le bon contexte
        // Ici on n'appelle pas `MethodChannel.Result.success()`, mais plutôt `stopBackgroundProcess` directement
        stopBackgroundProcess(object : MethodChannel.Result {
            override fun success(result: Any?) {
                // Cette méthode n'est pas utilisée ici, mais nous pouvons l'implémenter pour éviter l'erreur
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                // Vous pouvez gérer les erreurs ici si nécessaire
            }

            override fun notImplemented() {
                // Cette méthode est utilisée si la méthode n'est pas implémentée
            }
        })
    }
}
