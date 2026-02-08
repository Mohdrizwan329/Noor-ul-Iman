package com.example.nooruliman

import android.Manifest
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "com.nooruliman.app/battery"
    private val AZAN_CHANNEL = "com.nooruliman.app/azan"
    private val PERMISSION_CHANNEL = "com.nooruliman.app/permissions"

    private val NOTIFICATION_PERMISSION_CODE = 1001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register native ad factory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "listTile",
            ListTileNativeAdFactory(this)
        )

        // Battery optimization channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isBatteryOptimizationDisabled" -> {
                    result.success(isBatteryOptimizationDisabled())
                }
                "requestDisableBatteryOptimization" -> {
                    requestDisableBatteryOptimization()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Azan service channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AZAN_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playAzan" -> {
                    val url = call.argument<String>("url")
                    val prayerName = call.argument<String>("prayerName") ?: "Prayer"
                    if (url != null) {
                        playAzan(url, prayerName)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "URL is required", null)
                    }
                }
                "stopAzan" -> {
                    stopAzan()
                    result.success(true)
                }
                "scheduleAzanAlarm" -> {
                    val alarmId = call.argument<Int>("alarmId") ?: 0
                    val triggerTimeMillis = call.argument<Long>("triggerTimeMillis") ?: 0L
                    val url = call.argument<String>("url") ?: ""
                    val prayerName = call.argument<String>("prayerName") ?: "Prayer"
                    scheduleAzanAlarm(alarmId, triggerTimeMillis, url, prayerName)
                    result.success(true)
                }
                "cancelAzanAlarm" -> {
                    val alarmId = call.argument<Int>("alarmId") ?: 0
                    cancelAzanAlarm(alarmId)
                    result.success(true)
                }
                "cancelAllAzanAlarms" -> {
                    cancelAllAzanAlarms()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Permissions channel for Azan background functionality
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "canScheduleExactAlarms" -> {
                    result.success(canScheduleExactAlarms())
                }
                "requestExactAlarmPermission" -> {
                    requestExactAlarmPermission()
                    result.success(true)
                }
                "hasNotificationPermission" -> {
                    result.success(hasNotificationPermission())
                }
                "requestNotificationPermission" -> {
                    requestNotificationPermission()
                    result.success(true)
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(true)
                }
                "openAlarmSettings" -> {
                    openAlarmSettings()
                    result.success(true)
                }
                "openAutoStartSettings" -> {
                    openAutoStartSettings()
                    result.success(true)
                }
                "getAllPermissionStatus" -> {
                    result.success(getAllPermissionStatus())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // ========== Permission Methods ==========

    private fun canScheduleExactAlarms(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            return alarmManager.canScheduleExactAlarms()
        }
        return true // Below Android 12, exact alarms are always allowed
    }

    private fun requestExactAlarmPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Try multiple intents for different phone manufacturers
            val intents = listOf(
                // Standard Android 12+ alarm permission
                Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                    data = Uri.parse("package:$packageName")
                },
                // Alternative for some devices
                Intent("android.settings.APP_NOTIFICATION_SETTINGS").apply {
                    putExtra("android.provider.extra.APP_PACKAGE", packageName)
                },
                // Xiaomi specific
                Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                    putExtra("extra_pkgname", packageName)
                },
                // Oppo/Realme specific
                Intent().apply {
                    setClassName("com.coloros.safecenter",
                        "com.coloros.safecenter.permission.startup.StartupAppListActivity")
                },
                // Vivo specific
                Intent().apply {
                    setClassName("com.vivo.permissionmanager",
                        "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")
                },
                // Huawei specific
                Intent().apply {
                    setClassName("com.huawei.systemmanager",
                        "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
                }
            )

            for (intent in intents) {
                try {
                    if (intent.resolveActivity(packageManager) != null) {
                        startActivity(intent)
                        return
                    }
                } catch (e: Exception) {
                    // Try next intent
                }
            }

            // Final fallback to app settings
            openAppSettings()
        }
    }

    private fun hasNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true // Below Android 13, notification permission is granted by default
        }
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                NOTIFICATION_PERMISSION_CODE
            )
        }
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
        }
        startActivity(intent)
    }

    private fun openAlarmSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            requestExactAlarmPermission()
        } else {
            openAppSettings()
        }
    }

    private fun openAutoStartSettings() {
        // For Chinese phones that need autostart permission
        val intents = listOf(
            // Xiaomi
            Intent().apply {
                setClassName("com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity")
            },
            // Xiaomi alternative
            Intent("miui.intent.action.OP_AUTO_START").apply {
                addCategory(Intent.CATEGORY_DEFAULT)
            },
            // Oppo
            Intent().apply {
                setClassName("com.coloros.safecenter",
                    "com.coloros.safecenter.permission.startup.StartupAppListActivity")
            },
            // Oppo alternative
            Intent().apply {
                setClassName("com.oppo.safe",
                    "com.oppo.safe.permission.startup.StartupAppListActivity")
            },
            // Vivo
            Intent().apply {
                setClassName("com.vivo.permissionmanager",
                    "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")
            },
            // Vivo alternative
            Intent().apply {
                setClassName("com.iqoo.secure",
                    "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")
            },
            // Huawei
            Intent().apply {
                setClassName("com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
            },
            // Huawei alternative
            Intent().apply {
                setClassName("com.huawei.systemmanager",
                    "com.huawei.systemmanager.optimize.process.ProtectActivity")
            },
            // Samsung
            Intent().apply {
                setClassName("com.samsung.android.lool",
                    "com.samsung.android.sm.ui.battery.BatteryActivity")
            },
            // OnePlus
            Intent().apply {
                setClassName("com.oneplus.security",
                    "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity")
            },
            // Realme
            Intent().apply {
                setClassName("com.coloros.safecenter",
                    "com.coloros.safecenter.startupapp.StartupAppListActivity")
            }
        )

        for (intent in intents) {
            try {
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    return
                }
            } catch (e: Exception) {
                // Try next intent
            }
        }

        // Fallback to app settings
        openAppSettings()
    }

    private fun getAllPermissionStatus(): Map<String, Any> {
        return mapOf(
            "exactAlarm" to canScheduleExactAlarms(),
            "notification" to hasNotificationPermission(),
            "batteryOptimization" to isBatteryOptimizationDisabled(),
            "androidVersion" to Build.VERSION.SDK_INT
        )
    }

    // ========== Battery Optimization Methods ==========

    private fun isBatteryOptimizationDisabled(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            return powerManager.isIgnoringBatteryOptimizations(packageName)
        }
        return true
    }

    private fun requestDisableBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
        }
    }

    private fun playAzan(url: String, prayerName: String) {
        val intent = Intent(this, AzanService::class.java).apply {
            action = AzanService.ACTION_PLAY
            putExtra(AzanService.EXTRA_AZAN_URL, url)
            putExtra(AzanService.EXTRA_PRAYER_NAME, prayerName)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopAzan() {
        val intent = Intent(this, AzanService::class.java).apply {
            action = AzanService.ACTION_STOP
        }
        startService(intent)
    }

    private fun scheduleAzanAlarm(alarmId: Int, triggerTimeMillis: Long, url: String, prayerName: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(this, AzanAlarmReceiver::class.java).apply {
            putExtra(AzanAlarmReceiver.EXTRA_AZAN_URL, url)
            putExtra(AzanAlarmReceiver.EXTRA_PRAYER_NAME, prayerName)
            putExtra(AzanAlarmReceiver.EXTRA_ALARM_ID, alarmId)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            this,
            alarmId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Cancel any existing alarm with same ID
        alarmManager.cancel(pendingIntent)

        // Create show intent for when user taps on alarm notification
        val showIntent = Intent(this, MainActivity::class.java)
        val showPendingIntent = PendingIntent.getActivity(
            this,
            alarmId + 1000,
            showIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Use setAlarmClock - MOST RELIABLE method
        // Android treats this as a user-set alarm and will NEVER skip it
        // This works even with battery optimization ON
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerTimeMillis, showPendingIntent)
            alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
            android.util.Log.d("AzanAlarm", "Scheduled $prayerName alarm using setAlarmClock at $triggerTimeMillis")
        } else {
            // Fallback for older devices
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                triggerTimeMillis,
                pendingIntent
            )
        }
    }

    private fun cancelAzanAlarm(alarmId: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, AzanAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            alarmId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }

    private fun cancelAllAzanAlarms() {
        // Cancel alarms for all 5 prayers (IDs 100-104)
        for (id in 100..104) {
            cancelAzanAlarm(id)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
