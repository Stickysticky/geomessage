package com.olivier.ettlin.geomessage

import android.telephony.SmsManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.olivier.ettlin.geomessage/sms"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Définir un MethodChannel pour Flutter et Kotlin
        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSms") {
                val message = call.argument<String>("message")
                val phoneNumber = call.argument<String>("phoneNumber")

                if (message != null && phoneNumber != null) {
                    sendSms(message, phoneNumber)
                    result.success("SMS envoyé")
                } else {
                    result.error("INVALID_ARGUMENTS", "Message ou numéro de téléphone manquant", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Fonction pour envoyer un SMS
    private fun sendSms(message: String, phoneNumber: String) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNumber, null, message, null, null)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
