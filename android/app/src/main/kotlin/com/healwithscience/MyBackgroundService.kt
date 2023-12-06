package com.healwithscience

import android.app.*
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.support.v4.media.session.MediaSessionCompat
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.getSystemService

class MyBackgroundService : Service() {

    private lateinit var mediaSession: MediaSessionCompat

    override fun onCreate() {
        super.onCreate()
        showNotification()
        mediaSession = MediaSessionCompat(this, "MyBackgroundService")
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        if (intent.action == ACTION_NEXT) {
            // Handle "Next" button click here
//            showToast("Next button clicked")
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaSession.release()
    }

    private fun showNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT
            )
            getSystemService<NotificationManager>()?.createNotificationChannel(channel)
        }

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.play) // Set your desired icon here
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(createMiniPlayerView())
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }


    private fun createMiniPlayerView(): RemoteViews {
        // Create a RemoteViews for the custom content view of the notification
        val miniPlayerView = RemoteViews(packageName, R.layout.notification_mini_player)

        miniPlayerView.setOnClickPendingIntent(
            R.id.nextButton,
            getPendingIntentForNextButtonClick()
        )

        // Customize the mini player view as needed

        return miniPlayerView
    }

    private fun getPendingIntentForNextButtonClick(): PendingIntent {
        val intent = Intent(this, MyBackgroundService::class.java)
        intent.action = ACTION_NEXT  // You can define this constant as a string in your companion object

        return PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    }

    companion object {
        private const val CHANNEL_ID = "my_background_service_channel"
        private const val CHANNEL_NAME = "Background Service Channel"
        private const val NOTIFICATION_ID = 1
        private const val ACTION_NEXT = "com.healwithscience.ACTION_NEXT"
    }
}
