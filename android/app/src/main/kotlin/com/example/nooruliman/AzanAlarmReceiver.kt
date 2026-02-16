package com.example.nooruliman

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AzanAlarmReceiver : BroadcastReceiver() {
    companion object {
        const val EXTRA_AZAN_URL = "azan_url"
        const val EXTRA_PRAYER_NAME = "prayer_name"
        const val EXTRA_ALARM_ID = "alarm_id"
        const val EXTRA_CACHED_PATH = "cached_path"
        private const val TAG = "AzanAlarmReceiver"
        private const val NOTIFICATION_CHANNEL_ID = "azan_channel"
        private const val PREFS_NAME = "FlutterSharedPreferences"

        // Prayer time keys matching Flutter side (prefixed with "flutter.")
        private val PRAYER_TIME_KEYS = mapOf(
            100 to "flutter.last_fajr_time",   // Fajr
            101 to "flutter.last_dhuhr_time",   // Dhuhr
            102 to "flutter.last_asr_time",     // Asr
            103 to "flutter.last_maghrib_time",  // Maghrib
            104 to "flutter.last_isha_time"     // Isha
        )

        // Multilingual prayer names
        private val PRAYER_NAMES = mapOf(
            "en" to mapOf("Fajr" to "Fajr", "Dhuhr" to "Dhuhr", "Asr" to "Asr", "Maghrib" to "Maghrib", "Isha" to "Isha"),
            "ur" to mapOf("Fajr" to "فجر", "Dhuhr" to "ظہر", "Asr" to "عصر", "Maghrib" to "مغرب", "Isha" to "عشاء"),
            "ar" to mapOf("Fajr" to "الفجر", "Dhuhr" to "الظهر", "Asr" to "العصر", "Maghrib" to "المغرب", "Isha" to "العشاء"),
            "hi" to mapOf("Fajr" to "फज्र", "Dhuhr" to "ज़ुहर", "Asr" to "अस्र", "Maghrib" to "मग़रिब", "Isha" to "ईशा")
        )

        private val PRAYER_TIME_TITLE = mapOf(
            "en" to "Prayer Time",
            "ur" to "نماز کا وقت",
            "ar" to "وقت الصلاة",
            "hi" to "नमाज़ का वक़्त"
        )

        private val ITS_TIME_FOR = mapOf(
            "en" to "It's time for",
            "ur" to "کا وقت ہو گیا",
            "ar" to "حان وقت",
            "hi" to "का वक़्त हो गया"
        )

        private val PRAYER_WORD = mapOf(
            "en" to "prayer",
            "ur" to "نماز",
            "ar" to "صلاة",
            "hi" to "नमाज़"
        )
    }

    override fun onReceive(context: Context, intent: Intent) {
        val azanUrl = intent.getStringExtra(EXTRA_AZAN_URL) ?: return
        val prayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "Prayer"
        val alarmId = intent.getIntExtra(EXTRA_ALARM_ID, -1)
        val cachedPath = intent.getStringExtra(EXTRA_CACHED_PATH) ?: ""

        Log.d(TAG, "Azan alarm fired for $prayerName (ID: $alarmId)")

        // Get user's selected language
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val langCode = prefs.getString("flutter.selected_language", "en") ?: "en"

        // Get translated notification text
        val title = getTranslatedTitle(prayerName, langCode)
        val body = getTranslatedBody(prayerName, langCode)

        // Show a persistent prayer time notification
        showPrayerNotification(context, title, body, alarmId)

        // Save notification to SharedPreferences for Flutter notification screen
        saveNotificationToHistory(context, title, body, alarmId)

        // Check if azan sound is enabled
        val azanSoundEnabled = prefs.getBoolean("flutter.azan_sound", true)

        if (azanSoundEnabled) {
            // Start the foreground service to play Azan audio
            val serviceIntent = Intent(context, AzanService::class.java).apply {
                action = AzanService.ACTION_PLAY
                putExtra(AzanService.EXTRA_AZAN_URL, azanUrl)
                putExtra(AzanService.EXTRA_PRAYER_NAME, prayerName)
                putExtra(AzanService.EXTRA_CACHED_PATH, cachedPath)
            }

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
                Log.d(TAG, "AzanService started successfully for $prayerName")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start AzanService: ${e.message}", e)
                // Fallback: play azan audio directly from the BroadcastReceiver
                playAzanFallback(context, azanUrl, cachedPath, prayerName)
            }
        } else {
            Log.d(TAG, "Azan sound disabled, skipping audio playback for $prayerName")
        }

        // Reschedule for tomorrow using saved prayer times
        if (alarmId >= 0) {
            rescheduleForTomorrow(context, alarmId, azanUrl, prayerName, cachedPath)
        }
    }

    /**
     * Get translated notification title based on user's language
     */
    private fun getTranslatedTitle(prayerName: String, langCode: String): String {
        val lang = if (listOf("en", "ur", "ar", "hi").contains(langCode)) langCode else "en"
        val translatedPrayer = PRAYER_NAMES[lang]?.get(prayerName) ?: prayerName
        val timeText = PRAYER_TIME_TITLE[lang] ?: "Prayer Time"
        return "$translatedPrayer - $timeText"
    }

    /**
     * Get translated notification body based on user's language
     */
    private fun getTranslatedBody(prayerName: String, langCode: String): String {
        val lang = if (listOf("en", "ur", "ar", "hi").contains(langCode)) langCode else "en"
        val translatedPrayer = PRAYER_NAMES[lang]?.get(prayerName) ?: prayerName
        val itsTime = ITS_TIME_FOR[lang] ?: "It's time for"
        val prayerWord = PRAYER_WORD[lang] ?: "prayer"

        return when (lang) {
            "ur" -> "$translatedPrayer $prayerWord $itsTime"
            "ar" -> "$itsTime $translatedPrayer"
            "hi" -> "$translatedPrayer $prayerWord $itsTime"
            else -> "$itsTime $translatedPrayer $prayerWord"
        }
    }

    /**
     * Show a persistent notification for the prayer time.
     * Uses the same channel as flutter_local_notifications for consistency.
     */
    private fun showPrayerNotification(context: Context, title: String, body: String, alarmId: Int) {
        try {
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            // Create notification channel (same ID as flutter_local_notifications uses)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    NOTIFICATION_CHANNEL_ID,
                    "Azan Notifications",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Notifications for Islamic prayer times with Azan sound"
                    enableVibration(true)
                    enableLights(true)
                }
                notificationManager.createNotificationChannel(channel)
            }

            // Open app when notification is tapped
            val openIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val openPendingIntent = PendingIntent.getActivity(
                context,
                alarmId + 2000,
                openIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val notification = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(body)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_ALARM)
                .setAutoCancel(true)
                .setContentIntent(openPendingIntent)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .build()

            // Use unique notification ID per prayer (2000 + alarmId)
            notificationManager.notify(2000 + alarmId, notification)

            Log.d(TAG, "Prayer notification shown: $title")
        } catch (e: Exception) {
            Log.e(TAG, "Error showing prayer notification: ${e.message}")
        }
    }

    /**
     * Save the fired notification to SharedPreferences so the Flutter notification screen
     * can display it. This is critical because flutter_local_notifications may not fire
     * on real devices due to battery optimization, but native AlarmManager (setAlarmClock) does.
     */
    private fun saveNotificationToHistory(context: Context, title: String, body: String, alarmId: Int) {
        try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val existingJson = prefs.getString("flutter.received_notifications", "[]") ?: "[]"
            val notifications = JSONArray(existingJson)

            val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US)
            val nowStr = dateFormat.format(Date())

            val notification = JSONObject().apply {
                put("id", System.currentTimeMillis().toInt()) // Unique ID based on timestamp
                put("title", title)
                put("body", body)
                put("type", "prayer")
                put("receivedAt", nowStr)
            }

            // Insert at beginning (newest first)
            val newNotifications = JSONArray()
            newNotifications.put(notification)
            for (i in 0 until minOf(notifications.length(), 99)) {
                newNotifications.put(notifications.get(i))
            }

            prefs.edit().putString("flutter.received_notifications", newNotifications.toString()).apply()
            Log.d(TAG, "Notification saved to history: $title")
        } catch (e: Exception) {
            Log.e(TAG, "Error saving notification to history: ${e.message}")
        }
    }

    /**
     * Reschedule alarm for tomorrow using saved prayer times from SharedPreferences.
     * Uses actual saved time instead of +24 hours to reduce drift.
     */
    private fun rescheduleForTomorrow(context: Context, alarmId: Int, azanUrl: String, prayerName: String, cachedPath: String) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        // Try to get saved prayer time for better accuracy
        var triggerTime = calculateTomorrowTriggerTime(context, alarmId)

        // Fallback to +24 hours if saved time not available
        if (triggerTime <= 0) {
            triggerTime = System.currentTimeMillis() + 24 * 60 * 60 * 1000L
            Log.d(TAG, "Using +24h fallback for $prayerName reschedule")
        }

        val intent = Intent(context, AzanAlarmReceiver::class.java).apply {
            putExtra(EXTRA_AZAN_URL, azanUrl)
            putExtra(EXTRA_PRAYER_NAME, prayerName)
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_CACHED_PATH, cachedPath)
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
        } catch (se: SecurityException) {
            // Exact alarm permission denied - fallback to inexact
            Log.w(TAG, "Exact alarm denied for rescheduling $prayerName, using fallback: ${se.message}")
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
                } else {
                    alarmManager.set(AlarmManager.RTC_WAKEUP, triggerTime, pendingIntent)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Failed to reschedule $prayerName even with fallback: ${e.message}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error rescheduling $prayerName alarm: ${e.message}")
        }
    }

    /**
     * Calculate tomorrow's trigger time using saved prayer times from SharedPreferences.
     * This is more accurate than just adding 24 hours.
     */
    private fun calculateTomorrowTriggerTime(context: Context, alarmId: Int): Long {
        try {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val timeKey = PRAYER_TIME_KEYS[alarmId] ?: return -1
            val timeString = prefs.getString(timeKey, null) ?: return -1

            val parsedTime = parseTimeString(timeString) ?: return -1

            val calendar = java.util.Calendar.getInstance().apply {
                add(java.util.Calendar.DAY_OF_MONTH, 1) // Tomorrow
                set(java.util.Calendar.HOUR_OF_DAY, parsedTime.first)
                set(java.util.Calendar.MINUTE, parsedTime.second)
                set(java.util.Calendar.SECOND, 0)
                set(java.util.Calendar.MILLISECOND, 0)
            }

            Log.d(TAG, "Calculated tomorrow trigger from saved time: ${calendar.time}")
            return calendar.timeInMillis
        } catch (e: Exception) {
            Log.e(TAG, "Error calculating tomorrow trigger: ${e.message}")
            return -1
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

    /**
     * Fallback: Play azan audio directly when AzanService fails to start.
     * This handles cases where foreground service restrictions prevent AzanService
     * from starting (Android 12+ background restrictions).
     */
    private fun playAzanFallback(context: Context, azanUrl: String, cachedPath: String, prayerName: String) {
        Log.d(TAG, "Playing azan via fallback for $prayerName")
        try {
            // Acquire wake lock to keep CPU running during playback
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "NoorulIman::AzanFallbackWakeLock"
            ).apply {
                acquire(5 * 60 * 1000L) // 5 minutes max
            }

            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

            // Ensure alarm volume is audible
            val alarmVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
            val maxAlarmVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            if (alarmVolume == 0) {
                val targetVolume = (maxAlarmVolume * 0.7).toInt().coerceAtLeast(1)
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, targetVolume, 0)
                Log.d(TAG, "Fallback: Alarm volume was 0, set to $targetVolume")
            }

            // Determine audio source
            val cachedFile = if (cachedPath.isNotEmpty()) java.io.File(cachedPath) else null
            val useCachedFile = cachedFile != null && cachedFile.exists() && cachedFile.length() > 0

            val mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )
                setVolume(1.0f, 1.0f)

                if (useCachedFile) {
                    setDataSource(cachedPath)
                } else {
                    setDataSource(azanUrl)
                }

                setOnPreparedListener { mp ->
                    try {
                        mp.start()
                        Log.d(TAG, "Fallback: Azan playing for $prayerName")
                    } catch (e: Exception) {
                        Log.e(TAG, "Fallback: Error starting playback: ${e.message}")
                        wakeLock.release()
                    }
                }
                setOnCompletionListener {
                    it.release()
                    wakeLock.release()
                    Log.d(TAG, "Fallback: Azan completed for $prayerName")
                }
                setOnErrorListener { mp, what, extra ->
                    Log.e(TAG, "Fallback: MediaPlayer error: what=$what, extra=$extra")
                    mp.release()
                    wakeLock.release()
                    true
                }
                prepareAsync()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Fallback azan playback failed: ${e.message}", e)
        }
    }
}
