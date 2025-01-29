package com.olivier.ettlin.geomessage.model

import java.util.*

data class Message(
    var id: Int? = null,
    var libelle: String? = null,
    var message: String,
    var latitude: Double,
    var longitude: Double,
    var phoneNumber: String,
    var date: Date? = null,
    var radius: Double = 30.0
) {
    // Convertit un Message en Map (pour SQLite)
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "id" to id,
            "libelle" to libelle,
            "message" to message,
            "latitude" to latitude,
            "longitude" to longitude,
            "phoneNumber" to phoneNumber,
            "radius" to radius,
            "date" to date?.toString()
        )
    }

    // Convertit un Map de SQLite en objet Message
    companion object {
        fun fromMap(map: Map<String, Any?>): Message {
            return Message(
                id = map["id"] as? Int,
                libelle = map["libelle"] as? String,
                message = map["message"] as String,
                latitude = map["latitude"] as Double,
                longitude = map["longitude"] as Double,
                phoneNumber = map["phoneNumber"] as String,
                radius = map["radius"] as Double,
                date = map["date"]?.let { Date(it.toString()) }
            )
        }
    }
}
