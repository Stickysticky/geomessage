package com.olivier.ettlin.geomessage

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.olivier.ettlin.geomessage.service.MyForegroundService
import android.os.Build
import android.util.Log

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.olivier.ettlin.geomessage/background"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startForegroundProcess" -> {
                    Log.d("foreground service", "2")
                    val intent = Intent(this, MyForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stopForegroundProcess" -> {
                    val intent = Intent(this, MyForegroundService::class.java)
                    stopService(intent) // Arrêter le service
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}