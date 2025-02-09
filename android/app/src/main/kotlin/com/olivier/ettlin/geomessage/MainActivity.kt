package com.olivier.ettlin.geomessage

import android.telephony.SmsManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.Manifest
import android.annotation.TargetApi
import androidx.core.app.ActivityCompat
import android.content.pm.PackageManager
import android.os.Build

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.olivier.ettlin.geomessage/sms"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Définir un MethodChannel pour Flutter et Kotlin
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    Log.e("MessageService", "ICI")
                    val message = call.argument<String>("message")
                    val phoneNumber = call.argument<String>("phoneNumber")

                    if (message != null && phoneNumber != null) {
                        sendSms(message, phoneNumber)
                        result.success("SMS envoyé")
                    } else {
                        result.error("INVALID_ARGUMENTS", "Message ou numéro de téléphone manquant", null)
                    }
                }
                "test" -> {
                    Log.e("MessageService", "TEST")
                }
                else -> result.notImplemented()
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.DONUT)
    private fun sendSms(messageText: String, phoneNumber: String) {
        // Vérifier la permission SEND_SMS
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            Log.e("MessageService", "Permission SEND_SMS non accordée")
            return
        }

        try {
            val smsManager: SmsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNumber, null, messageText, null, null)
            Log.d("MessageService", "SMS envoyé à $phoneNumber: $messageText")
        } catch (e: SecurityException) {
            Log.e("MessageService", "Permission manquante pour envoyer le SMS: ${e.localizedMessage}")
        } catch (e: Throwable) {  // Utilisez Throwable pour capturer toutes les exceptions
            Log.e("MessageService", "Erreur lors de l'envoi du SMS: ${e.localizedMessage}")
        }
    }
}
