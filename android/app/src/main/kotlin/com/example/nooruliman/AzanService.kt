package com.example.nooruliman

import android.app.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat

class AzanService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null
    private var stopReceiver: BroadcastReceiver? = null
    private var isAzanPlaying = false

    companion object {
        const val CHANNEL_ID = "azan_service_channel"
        const val NOTIFICATION_ID = 1001
        const val ACTION_PLAY = "com.nooruliman.PLAY_AZAN"
        const val ACTION_STOP = "com.nooruliman.STOP_AZAN"
        const val EXTRA_AZAN_URL = "azan_url"
        const val EXTRA_PRAYER_NAME = "prayer_name"
        const val EXTRA_CACHED_PATH = "cached_path"
        private const val TAG = "AzanService"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "AzanService onCreate")
        createNotificationChannel()
        acquireWakeLock()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        registerStopReceiver()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "onStartCommand action=${intent?.action}")
        when (intent?.action) {
            ACTION_PLAY -> {
                val azanUrl = intent.getStringExtra(EXTRA_AZAN_URL) ?: return START_NOT_STICKY
                val prayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "Prayer"
                val cachedPath = intent.getStringExtra(EXTRA_CACHED_PATH) ?: ""
                Log.d(TAG, "Playing azan for $prayerName, URL: $azanUrl, cached: $cachedPath")
                playAzan(azanUrl, prayerName, cachedPath)
            }
            ACTION_STOP -> {
                Log.d(TAG, "Stopping azan")
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

    /**
     * Register receiver to stop azan when user presses volume or lock/power button.
     * Volume button = android.media.VOLUME_CHANGED_ACTION
     * Lock/Power button = Intent.ACTION_SCREEN_OFF
     */
    private fun registerStopReceiver() {
        stopReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (!isAzanPlaying) return
                when (intent?.action) {
                    "android.media.VOLUME_CHANGED_ACTION" -> {
                        Log.d(TAG, "Volume button pressed - stopping azan")
                        stopAzan()
                        stopSelf()
                    }
                    Intent.ACTION_SCREEN_OFF -> {
                        Log.d(TAG, "Lock/Power button pressed - stopping azan")
                        stopAzan()
                        stopSelf()
                    }
                }
            }
        }
        val filter = IntentFilter().apply {
            addAction("android.media.VOLUME_CHANGED_ACTION")
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(stopReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(stopReceiver, filter)
        }
        Log.d(TAG, "Stop receiver registered for volume & lock button")
    }

    private fun unregisterStopReceiver() {
        try {
            stopReceiver?.let { unregisterReceiver(it) }
            stopReceiver = null
            Log.d(TAG, "Stop receiver unregistered")
        } catch (e: Exception) {
            Log.d(TAG, "Stop receiver already unregistered: ${e.message}")
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

    private fun requestAudioFocus(): Boolean {
        val am = audioManager ?: return false

        // Ensure alarm volume is audible FIRST - before requesting focus
        val alarmVolume = am.getStreamVolume(AudioManager.STREAM_ALARM)
        val maxAlarmVolume = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
        Log.d(TAG, "Alarm stream volume: $alarmVolume / $maxAlarmVolume")

        if (alarmVolume == 0) {
            // Set alarm volume to 70% of max so user can hear it
            val targetVolume = (maxAlarmVolume * 0.7).toInt().coerceAtLeast(1)
            am.setStreamVolume(AudioManager.STREAM_ALARM, targetVolume, 0)
            Log.d(TAG, "Alarm volume was 0, set to $targetVolume")
        }

        // Also check notification/ring volume for good measure
        try {
            val ringVolume = am.getStreamVolume(AudioManager.STREAM_RING)
            val musicVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC)
            Log.d(TAG, "Ring volume: $ringVolume, Music volume: $musicVolume")
        } catch (e: Exception) {
            Log.d(TAG, "Could not check other volumes: ${e.message}")
        }

        // Use AUDIOFOCUS_GAIN to properly interrupt other audio (not just duck)
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )
                .setWillPauseWhenDucked(false)
                .build()
            audioFocusRequest = focusRequest
            val result = am.requestAudioFocus(focusRequest)
            Log.d(TAG, "Audio focus request result: $result (GRANTED=${AudioManager.AUDIOFOCUS_REQUEST_GRANTED})")
            result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        } else {
            @Suppress("DEPRECATION")
            val result = am.requestAudioFocus(
                null,
                AudioManager.STREAM_ALARM,
                AudioManager.AUDIOFOCUS_GAIN
            )
            Log.d(TAG, "Audio focus request result (legacy): $result")
            result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        }
    }

    private fun abandonAudioFocus() {
        val am = audioManager ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocusRequest?.let { am.abandonAudioFocusRequest(it) }
        } else {
            @Suppress("DEPRECATION")
            am.abandonAudioFocus(null)
        }
    }

    private fun playAzan(url: String, prayerName: String, cachedPath: String = "") {
        // Start foreground service with notification IMMEDIATELY (before any other work)
        try {
            val notification = createNotification(prayerName)
            startForeground(NOTIFICATION_ID, notification)
            Log.d(TAG, "Foreground service started for $prayerName")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground: ${e.message}", e)
            // Continue anyway - try to play audio even without foreground
        }

        // Request audio focus (continue even if denied - alarm audio should still play)
        val hasFocus = requestAudioFocus()
        Log.d(TAG, "Audio focus obtained: $hasFocus (continuing regardless)")

        // Stop any existing playback
        mediaPlayer?.release()
        mediaPlayer = null

        // Determine audio source: try cached file first, fallback to URL
        val cachedFile = if (cachedPath.isNotEmpty()) java.io.File(cachedPath) else null
        val useCachedFile = cachedFile != null && cachedFile.exists() && cachedFile.length() > 0

        Log.d(TAG, "Using ${if (useCachedFile) "cached file: $cachedPath" else "network URL: $url"}")

        try {
            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )

                // Set volume to max on this player
                setVolume(1.0f, 1.0f)

                if (useCachedFile) {
                    // Use cached local file (works offline)
                    setDataSource(cachedPath)
                    Log.d(TAG, "DataSource set to cached file")
                } else {
                    // Fallback to network URL
                    setDataSource(url)
                    Log.d(TAG, "DataSource set to network URL")
                }

                setOnPreparedListener { mp ->
                    Log.d(TAG, "MediaPlayer prepared, starting playback. Duration: ${mp.duration}ms")
                    try {
                        mp.start()
                        isAzanPlaying = true
                        Log.d(TAG, "MediaPlayer started playing")
                    } catch (e: Exception) {
                        Log.e(TAG, "Error starting MediaPlayer after prepare: ${e.message}", e)
                        stopSelf()
                    }
                }

                setOnCompletionListener {
                    Log.d(TAG, "Azan playback completed")
                    isAzanPlaying = false
                    stopSelf()
                }

                setOnErrorListener { _, what, extra ->
                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                    // If cached file failed, retry with network URL
                    if (useCachedFile) {
                        Log.d(TAG, "Cached file failed, retrying with network URL...")
                        retryWithUrl(url, prayerName)
                    } else {
                        stopSelf()
                    }
                    true
                }

                setOnInfoListener { _, what, extra ->
                    Log.d(TAG, "MediaPlayer info: what=$what, extra=$extra")
                    false
                }

                prepareAsync()
                Log.d(TAG, "prepareAsync called, waiting for onPrepared callback...")
            }

            // Timeout: if prepareAsync doesn't callback in 15 seconds, retry with URL
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                val mp = mediaPlayer
                if (mp != null && !mp.isPlaying) {
                    Log.w(TAG, "prepareAsync timeout - MediaPlayer not playing after 15s")
                    if (useCachedFile) {
                        Log.d(TAG, "Timeout with cached file, retrying with network URL...")
                        retryWithUrl(url, prayerName)
                    } else {
                        Log.e(TAG, "Timeout with network URL, stopping service")
                        stopSelf()
                    }
                }
            }, 15000)
        } catch (e: Exception) {
            Log.e(TAG, "Exception in playAzan: ${e.message}", e)
            // If cached file caused the exception, try URL
            if (useCachedFile) {
                Log.d(TAG, "Cached file exception, retrying with network URL...")
                retryWithUrl(url, prayerName)
            } else {
                stopSelf()
            }
        }
    }

    /// Retry playback using network URL when cached file fails
    private fun retryWithUrl(url: String, prayerName: String) {
        try {
            mediaPlayer?.release()
            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )
                setVolume(1.0f, 1.0f)
                setDataSource(url)

                setOnPreparedListener { mp ->
                    try {
                        mp.start()
                        isAzanPlaying = true
                        Log.d(TAG, "Retry: MediaPlayer started with URL")
                    } catch (e: Exception) {
                        Log.e(TAG, "Retry: Error starting: ${e.message}")
                        stopSelf()
                    }
                }
                setOnCompletionListener {
                    isAzanPlaying = false
                    stopSelf()
                }
                setOnErrorListener { _, what, extra ->
                    Log.e(TAG, "Retry: MediaPlayer error: what=$what, extra=$extra")
                    stopSelf()
                    true
                }
                prepareAsync()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Retry failed: ${e.message}")
            stopSelf()
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

        // Open app when notification is tapped
        val openIntent = packageManager.getLaunchIntentForPackage(packageName)
        val openPendingIntent = PendingIntent.getActivity(
            this, 0, openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("$prayerName - Azan Playing")
            .setContentText("It's time for $prayerName prayer. Tap Stop to silence.")
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .addAction(android.R.drawable.ic_media_pause, "Stop Azan", stopPendingIntent)
            .setContentIntent(openPendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .build()
    }

    private fun stopAzan() {
        isAzanPlaying = false
        try {
            mediaPlayer?.apply {
                if (isPlaying) {
                    stop()
                    Log.d(TAG, "MediaPlayer stopped")
                }
                release()
                Log.d(TAG, "MediaPlayer released")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping MediaPlayer: ${e.message}", e)
        }
        mediaPlayer = null
        abandonAudioFocus()
    }

    override fun onDestroy() {
        Log.d(TAG, "AzanService onDestroy")
        stopAzan()
        unregisterStopReceiver()
        wakeLock?.release()
        super.onDestroy()
    }
}
