package com.olivier.ettlin.geomessage.service

import android.content.Context
import android.location.Location
import android.os.Looper
import android.widget.Toast
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
    fun getCurrentLocation(callback: (Location) -> Unit) {
        if (!isLocationServiceEnabled()) {
            Toast.makeText(context, "Le service de localisation est désactivé.", Toast.LENGTH_SHORT).show()
            return
        }

        // Vérification des permissions de localisation
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
            ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // Demander les permissions si elles ne sont pas accordées
            return
        }

        // Récupérer la position actuelle
        fusedLocationClient.lastLocation.addOnCompleteListener { task: Task<Location?> ->
            val location = task.result
            if (location != null) {
                callback(location)
            } else {
                fusedLocationClient.requestLocationUpdates(
                    LocationRequest.create().apply {
                        interval = 10000
                        fastestInterval = 5000
                        priority = LocationRequest.PRIORITY_HIGH_ACCURACY
                    },
                    object : LocationCallback() {
                        override fun onLocationResult(locationResult: LocationResult) { // Utilisez directement LocationResult ici
                            if (locationResult.locations.isNotEmpty()) {
                                callback(locationResult.locations[0])
                                fusedLocationClient.removeLocationUpdates(this)
                            }
                        }
                    },
                    Looper.getMainLooper()
                )
            }
        }
    }

    // Vérifie si la localisation actuelle est dans le rayon du message
    fun checkCurrentLocationInRadius(message: Message, callback: (Boolean) -> Unit) {
        if (!isLocationServiceEnabled()) {
            //Toast.makeText(context, "GPS désactivé", Toast.LENGTH_SHORT).show()
            println("gps désactivé")
            callback(false)
            return
        }

        getCurrentLocation { location ->
            val distance = FloatArray(1)
            Location.distanceBetween(
                location.latitude,
                location.longitude,
                message.latitude,
                message.longitude,
                distance
            )

            val isInRadius = distance[0] <= message.radius
            println("Distance actuelle : ${distance[0]} mètres, Rayon autorisé : ${message.radius} mètres")
            callback(isInRadius)
        }
    }
}
