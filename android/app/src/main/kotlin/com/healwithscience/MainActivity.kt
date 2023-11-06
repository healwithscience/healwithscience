package com.healwithscience

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.PI
import kotlin.math.sin

class MainActivity : FlutterActivity() {

    private val channelName = "nativeBridge"
    private var isPlaying: Boolean = false
    private lateinit var audioTrack: AudioTrack

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            print("HelloNativeCall===>")
            // This method is invoked on the main thread.
            if (call.method == "playMusic") {
//                Toast.makeText(this, "Native call", Toast.LENGTH_SHORT).show();
                val data = call.arguments as? Map<String, Any>
                if (data != null) {
                    val frequency = data["frequency"] as Double
                    val duty_cycle = data["duty_cycle"] as Double
                    val amplitude = data["amplitude"] as Double
                    val offset = data["offset"] as Double
                    val phase = data["phase"] as Double

                    generateAndPlayAudio(frequency, duty_cycle, amplitude, offset, phase)
                }

            } else if (call.method == "stopMusic") {
//                Toast.makeText(this, "Stop call", Toast.LENGTH_SHORT).show();

                stopAudioPlayback()
            } else {
                result.notImplemented()
            }
        }
    }


    private fun generateAndPlayAudio(
        frequency: Double,
        dutyCycle: Double,
        amplitude: Double,
        offset: Double,
        phase: Double
    ) {
        isPlaying = true
        val sampleRate = 11025
        val durationSeconds = 300
        val numSamples = sampleRate * durationSeconds

        audioTrack = AudioTrack(
            AudioManager.STREAM_MUSIC,
            sampleRate,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            numSamples * 2,
            AudioTrack.MODE_STREAM
        )

        val buffer = ShortArray(numSamples)

        for (i in 0 until numSamples) {
            val t = i.toDouble() / sampleRate
            val value =
                (amplitude * sin(2 * PI * frequency * t + phase) * (if (t % 1 < dutyCycle) 1 else -1) + offset).toFloat()
            buffer[i] = (value * Short.MAX_VALUE).toInt().toShort()
        }

        audioTrack.play()
        audioTrack.write(buffer, 0, numSamples)
    }

    private fun stopAudioPlayback() {
        if (isPlaying) {
            isPlaying = false
            audioTrack.stop()
           audioTrack.release()
        }
    }


}
