package com.olivier.ettlin.geomessage.service

import android.content.Context
import android.location.Location
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*
import com.olivier.ettlin.geomessage.model.Message
import com.google.android.gms.tasks.Task
import android.Manifest
import android.content.pm.PackageManager

class LocalisationService(private val context: Context) {

    private val fusedLocationClient: FusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context)

    // Vérifie si le service de localisation est activé
    fun isLocationServiceEnabled(): Boolean {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as android.location.LocationManager
        return locationManager.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER)
    }

    // Fonction pour obtenir la localisation actuelle
    fun getCurrentLocation(callback: (Location?) -> Unit) {
        if (!isLocationServiceEnabled()) {
            println("GPS désactivé")
            callback(null)
            return
        }

        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            println("Permissions de localisation non accordées")
            callback(null)
            return
        }

        // Utilisation de getCurrentLocation pour une récupération instantanée
        fusedLocationClient.getCurrentLocation(LocationRequest.PRIORITY_HIGH_ACCURACY, null)
            .addOnSuccessListener { location ->
                callback(location) // Passe directement la localisation (null si indisponible)
            }
            .addOnFailureListener { exception ->
                println("Erreur lors de la récupération de la localisation : ${exception.message}")
                callback(null)
            }
    }

    fun checkCurrentLocationInRadius(message: Message, callback: (Boolean) -> Unit) {
        if (!isLocationServiceEnabled()) {
            println("GPS désactivé")
            callback(false)
            return
        }

        getCurrentLocation { location ->
            location?.let {
                val distance = FloatArray(1)
                Location.distanceBetween(
                    it.latitude, it.longitude,
                    message.latitude, message.longitude,
                    distance
                )

                val isInRadius = distance[0] <= message.radius
                println("Distance actuelle : ${distance[0]} mètres, Rayon autorisé : ${message.radius} mètres")
                callback(isInRadius)
            } ?: run {
                println("Impossible d'obtenir la localisation actuelle.")
                callback(false)
            }
        }
    }
}
