package com.example.nooruliman

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class AzanService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null

    companion object {
        const val CHANNEL_ID = "azan_service_channel"
        const val NOTIFICATION_ID = 1001
        const val ACTION_PLAY = "com.nooruliman.PLAY_AZAN"
        const val ACTION_STOP = "com.nooruliman.STOP_AZAN"
        const val EXTRA_AZAN_URL = "azan_url"
        const val EXTRA_PRAYER_NAME = "prayer_name"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_PLAY -> {
                val azanUrl = intent.getStringExtra(EXTRA_AZAN_URL) ?: return START_NOT_STICKY
                val prayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "Prayer"
                playAzan(azanUrl, prayerName)
            }
            ACTION_STOP -> {
                stopAzan()
                stopSelf()
            }
        }
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Azan Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Playing Azan for prayer time"
                setSound(null, null)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "NoorulIman::AzanWakeLock"
        ).apply {
            acquire(10 * 60 * 1000L) // 10 minutes max
        }
    }

    private fun playAzan(url: String, prayerName: String) {
        // Start foreground service with notification
        val notification = createNotification(prayerName)
        startForeground(NOTIFICATION_ID, notification)

        // Stop any existing playback
        mediaPlayer?.release()

        mediaPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build()
            )

            try {
                setDataSource(url)
                prepareAsync()
                setOnPreparedListener {
                    start()
                }
                setOnCompletionListener {
                    stopSelf()
                }
                setOnErrorListener { _, _, _ ->
                    stopSelf()
                    true
                }
            } catch (e: Exception) {
                e.printStackTrace()
                stopSelf()
            }
        }
    }

    private fun createNotification(prayerName: String): Notification {
        val stopIntent = Intent(this, AzanService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("$prayerName - Azan")
            .setContentText("Playing Azan...")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .addAction(android.R.drawable.ic_media_pause, "Stop", stopPendingIntent)
            .setOngoing(true)
            .build()
    }

    private fun stopAzan() {
        mediaPlayer?.apply {
            if (isPlaying) {
                stop()
            }
            release()
        }
        mediaPlayer = null
    }

    override fun onDestroy() {
        stopAzan()
        wakeLock?.release()
        super.onDestroy()
    }
}
