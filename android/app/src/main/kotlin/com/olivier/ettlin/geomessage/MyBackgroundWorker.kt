package com.olivier.ettlin.geomessage

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters

class MyBackgroundWorker(context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {

    override fun doWork(): Result {
        // Logique de votre tâche en arrière-plan
        Log.d("MyBackgroundWorker", "Exécution de la tâche en arrière-plan.")

        // Si le travail s'est bien passé
        return Result.success()
    }
}
