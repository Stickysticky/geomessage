package com.olivier.ettlin.geomessage.service

import android.content.Context
import android.content.ContentValues
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.olivier.ettlin.geomessage.model.Message
import java.io.File

class DatabaseService(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    private val context = context // Déclarer context ici

    companion object {
        private const val DATABASE_NAME = "geomessage.db"
        private const val DATABASE_VERSION = 1
        private var instance: DatabaseService? = null

        fun getInstance(context: Context): DatabaseService {
            if (instance == null) {
                instance = DatabaseService(context.applicationContext)
            }
            return instance!!
        }
    }

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL("""
            CREATE TABLE message (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                libelle TEXT,
                message TEXT NOT NULL,
                latitude REAL NOT NULL,
                longitude REAL NOT NULL,
                phoneNumber TEXT NOT NULL,
                date TEXT DEFAULT NULL,
                radius REAL NOT NULL
            )
        """)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS message")
        onCreate(db)
    }

    // Insère un message
    fun insertMessage(message: Message): Long {
        val db = writableDatabase
        val values = message.toMap().toContentValues() // Convertir Map en ContentValues
        return db.insert("message", null, values)
    }

    // Récupère un message par ID
    fun getMessageById(id: Int): Message? {
        val db = readableDatabase
        val cursor = db.query(
            "message",
            null,
            "id = ?",
            arrayOf(id.toString()),
            null, null, null
        )

        return if (cursor != null && cursor.moveToFirst()) {
            val message = Message.fromMap(cursorToMap(cursor))
            cursor.close()
            message
        } else {
            cursor?.close()
            null
        }
    }

    // Récupère les messages avec une date
    fun getMessagesWithDate(): List<Message> {
        val db = readableDatabase
        val cursor = db.query(
            "message",
            null,
            "date IS NOT NULL",
            null,
            null, null, null
        )
        return cursorToList(cursor)
    }

    // Récupère les messages sans date
    fun getMessagesWithoutDate(): List<Message> {
        val db = readableDatabase
        val cursor = db.query(
            "message",
            null,
            "date IS NULL",
            null,
            null, null, null
        )
        return cursorToList(cursor)
    }

    // Supprime un message par ID
    fun deleteMessage(id: Int): Int {
        val db = writableDatabase
        return db.delete(
            "message",
            "id = ?",
            arrayOf(id.toString())
        )
    }

    // Supprime la base de données
    fun deleteDatabaseFile() {
        val file = File(context.filesDir, DATABASE_NAME)
        if (file.exists()) {
            file.delete()
        }
    }

    // Convertir un curseur en liste de messages
    private fun cursorToList(cursor: android.database.Cursor): List<Message> {
        val messages = mutableListOf<Message>()
        if (cursor != null && cursor.moveToFirst()) {
            do {
                messages.add(Message.fromMap(cursorToMap(cursor)))
            } while (cursor.moveToNext())
        }
        cursor.close()
        return messages
    }

    // Convertir un curseur en Map
    private fun cursorToMap(cursor: android.database.Cursor): Map<String, Any?> {
        return mapOf(
            "id" to cursor.getInt(cursor.getColumnIndex("id")),
            "libelle" to cursor.getString(cursor.getColumnIndex("libelle")),
            "message" to cursor.getString(cursor.getColumnIndex("message")),
            "latitude" to cursor.getDouble(cursor.getColumnIndex("latitude")),
            "longitude" to cursor.getDouble(cursor.getColumnIndex("longitude")),
            "phoneNumber" to cursor.getString(cursor.getColumnIndex("phoneNumber")),
            "radius" to cursor.getDouble(cursor.getColumnIndex("radius")),
            "date" to cursor.getString(cursor.getColumnIndex("date"))
        )
    }

    // Extension de Map pour convertir en ContentValues
    private fun Map<String, Any?>.toContentValues(): ContentValues {
        val values = ContentValues()
        for (entry in this) {
            when (entry.value) {
                is String -> values.put(entry.key, entry.value as String)
                is Int -> values.put(entry.key, entry.value as Int)
                is Double -> values.put(entry.key, entry.value as Double)
                else -> values.put(entry.key, entry.value?.toString()) // Valeur par défaut
            }
        }
        return values
    }
}
