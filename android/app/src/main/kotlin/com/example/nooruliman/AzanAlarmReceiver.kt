package com.example.nooruliman

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class AzanAlarmReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_AZAN_URL = "azan_url"
        const val EXTRA_PRAYER_NAME = "prayer_name"
        const val EXTRA_ALARM_ID = "alarm_id"
        private const val TAG = "AzanAlarmReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val azanUrl = intent.getStringExtra(EXTRA_AZAN_URL) ?: return
        val prayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "Prayer"
        val alarmId = intent.getIntExtra(EXTRA_ALARM_ID, -1)

        Log.d(TAG, "Azan alarm fired for $prayerName (ID: $alarmId)")

        // Start the foreground service to play Azan
        val serviceIntent = Intent(context, AzanService::class.java).apply {
            action = AzanService.ACTION_PLAY
            putExtra(AzanService.EXTRA_AZAN_URL, azanUrl)
            putExtra(AzanService.EXTRA_PRAYER_NAME, prayerName)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        // Reschedule the same alarm for tomorrow (24 hours later)
        if (alarmId >= 0) {
            rescheduleForTomorrow(context, alarmId, azanUrl, prayerName)
        }
    }

    private fun rescheduleForTomorrow(context: Context, alarmId: Int, azanUrl: String, prayerName: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val triggerTime = System.currentTimeMillis() + 24 * 60 * 60 * 1000L // 24 hours from now

        val intent = Intent(context, AzanAlarmReceiver::class.java).apply {
            putExtra(EXTRA_AZAN_URL, azanUrl)
            putExtra(EXTRA_PRAYER_NAME, prayerName)
            putExtra(EXTRA_ALARM_ID, alarmId)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            alarmId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            // Use setAlarmClock - MOST RELIABLE method
            // Android treats this as a user-set alarm and will NEVER skip it
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val showIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                val showPendingIntent = PendingIntent.getActivity(
                    context,
                    alarmId + 1000,
                    showIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerTime, showPendingIntent)
                alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
                Log.d(TAG, "Rescheduled $prayerName azan using setAlarmClock for tomorrow (ID: $alarmId)")
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerTime,
                    pendingIntent
                )
                Log.d(TAG, "Rescheduled $prayerName azan for tomorrow (ID: $alarmId)")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error rescheduling $prayerName alarm: ${e.message}")
        }
    }
}
