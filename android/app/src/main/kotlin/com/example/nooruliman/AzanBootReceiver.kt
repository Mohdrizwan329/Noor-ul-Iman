package com.example.nooruliman

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

/**
 * BroadcastReceiver that reschedules Azan alarms after device reboot.
 * This ensures that prayer time notifications continue to work after the device restarts.
 */
class AzanBootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "AzanBootReceiver"
        private const val PREFS_NAME = "FlutterSharedPreferences"

        // Alarm IDs for each prayer (must match Flutter side)
        private const val FAJR_ALARM_ID = 100
        private const val DHUHR_ALARM_ID = 101
        private const val ASR_ALARM_ID = 102
        private const val MAGHRIB_ALARM_ID = 103
        private const val ISHA_ALARM_ID = 104

        // Prayer time keys in SharedPreferences (Flutter prefixes with "flutter.")
        private const val KEY_FAJR_TIME = "flutter.last_fajr_time"
        private const val KEY_DHUHR_TIME = "flutter.last_dhuhr_time"
        private const val KEY_ASR_TIME = "flutter.last_asr_time"
        private const val KEY_MAGHRIB_TIME = "flutter.last_maghrib_time"
        private const val KEY_ISHA_TIME = "flutter.last_isha_time"
        private const val KEY_AZAN_ENABLED = "flutter.azan_sound"
        private const val KEY_SELECTED_ADHAN = "flutter.selected_adhan"

        // Adhan URLs
        private val ADHAN_URLS = mapOf(
            "makkah" to "https://cdn.islamic.network/adhaan/128/ar.abdullahbasfaralhuthaify.mp3",
            "madinah" to "https://cdn.islamic.network/adhaan/128/ar.abdullahawadaljuhani.mp3",
            "alaqsa" to "https://cdn.islamic.network/adhaan/64/ar.misharyalafasy.mp3",
            "mishary" to "https://cdn.islamic.network/adhaan/128/ar.misharyalafasy.mp3",
            "abdul_basit" to "https://cdn.islamic.network/adhaan/128/ar.abdulbasitabdussamad.mp3"
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON" ||
            intent.action == "com.htc.intent.action.QUICKBOOT_POWERON") {

            Log.d(TAG, "Device booted, rescheduling Azan alarms...")
            rescheduleAzanAlarms(context)
        }
    }

    private fun rescheduleAzanAlarms(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        // Check if Azan is enabled
        val azanEnabled = prefs.getBoolean(KEY_AZAN_ENABLED, true)
        if (!azanEnabled) {
            Log.d(TAG, "Azan sound is disabled, skipping reschedule")
            return
        }

        // Get selected Adhan URL and cached file path
        val selectedAdhan = prefs.getString(KEY_SELECTED_ADHAN, "madinah") ?: "madinah"
        val azanUrl = ADHAN_URLS[selectedAdhan] ?: ADHAN_URLS["madinah"]!!
        val cachedPath = prefs.getString("flutter.cached_azan_path", "") ?: ""

        // Get saved prayer times and reschedule
        val prayerTimes = mapOf(
            "Fajr" to Pair(FAJR_ALARM_ID, prefs.getString(KEY_FAJR_TIME, null)),
            "Dhuhr" to Pair(DHUHR_ALARM_ID, prefs.getString(KEY_DHUHR_TIME, null)),
            "Asr" to Pair(ASR_ALARM_ID, prefs.getString(KEY_ASR_TIME, null)),
            "Maghrib" to Pair(MAGHRIB_ALARM_ID, prefs.getString(KEY_MAGHRIB_TIME, null)),
            "Isha" to Pair(ISHA_ALARM_ID, prefs.getString(KEY_ISHA_TIME, null))
        )

        for ((prayerName, prayerInfo) in prayerTimes) {
            val alarmId = prayerInfo.first
            val timeString = prayerInfo.second

            if (timeString != null) {
                scheduleAlarm(context, alarmId, prayerName, timeString, azanUrl, cachedPath)
            }
        }

        Log.d(TAG, "Azan alarms rescheduled after boot")
    }

    private fun scheduleAlarm(
        context: Context,
        alarmId: Int,
        prayerName: String,
        timeString: String,
        azanUrl: String,
        cachedPath: String = ""
    ) {
        val parsedTime = parseTimeString(timeString) ?: return

        val now = System.currentTimeMillis()
        val calendar = java.util.Calendar.getInstance().apply {
            set(java.util.Calendar.HOUR_OF_DAY, parsedTime.first)
            set(java.util.Calendar.MINUTE, parsedTime.second)
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }

        // If time has passed today, schedule for tomorrow
        if (calendar.timeInMillis <= now) {
            calendar.add(java.util.Calendar.DAY_OF_MONTH, 1)
        }

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, AzanAlarmReceiver::class.java).apply {
            putExtra(AzanAlarmReceiver.EXTRA_AZAN_URL, azanUrl)
            putExtra(AzanAlarmReceiver.EXTRA_PRAYER_NAME, prayerName)
            putExtra(AzanAlarmReceiver.EXTRA_ALARM_ID, alarmId)
            putExtra(AzanAlarmReceiver.EXTRA_CACHED_PATH, cachedPath)
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
                val alarmClockInfo = AlarmManager.AlarmClockInfo(calendar.timeInMillis, showPendingIntent)
                alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
                Log.d(TAG, "Scheduled $prayerName alarm using setAlarmClock for ${calendar.time}")
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    calendar.timeInMillis,
                    pendingIntent
                )
                Log.d(TAG, "Scheduled $prayerName alarm for ${calendar.time}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error scheduling $prayerName alarm: ${e.message}")
        }
    }

    private fun parseTimeString(timeStr: String): Pair<Int, Int>? {
        return try {
            val cleanTime = timeStr.trim().uppercase()
            val isPM = cleanTime.contains("PM")
            val isAM = cleanTime.contains("AM")

            val timeOnly = cleanTime
                .replace("AM", "")
                .replace("PM", "")
                .trim()

            val parts = timeOnly.split(":")
            if (parts.size < 2) return null

            var hour = parts[0].trim().toInt()
            val minute = parts[1].trim().toInt()

            if (isPM || isAM) {
                if (isPM && hour != 12) {
                    hour += 12
                } else if (isAM && hour == 12) {
                    hour = 0
                }
            }

            Pair(hour, minute)
        } catch (e: Exception) {
            Log.e(TAG, "Error parsing time: $timeStr - ${e.message}")
            null
        }
    }
}
