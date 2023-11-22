package com.healwithscience

import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.sin
import kotlin.math.sqrt


class MainActivity : FlutterActivity() {

    private val channelName = "nativeBridge"
    private var isPlaying: Boolean = false
    private lateinit var audioTrack: AudioTrack
    val sampleRate = 22050
    val durationSeconds = 300
    val numSamples = sampleRate * durationSeconds
    private val buffer = ByteArray(2 * durationSeconds * sampleRate)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->


            // This method is invoked on the main thread.
            if (call.method == "playMusic") {

                val data = call.arguments as? Map<String, Any>
                if (data != null) {
                    val frequency = data["frequency"] as Double
                    val duty_cycle = data["duty_cycle"] as Double
                    val amplitude = data["amplitude"] as Double
                    val offset = data["offset"] as Double
                    val phase = data["phase"] as Double
                    val waveType = data["wavetype"] as Int


                    generateAndPlayAudio(frequency, duty_cycle, amplitude, offset, phase, waveType)
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
        phase: Double,
        waveType: Int
    ) {
        isPlaying = true


        if (waveType == 1) {
            generateSineWave(amplitude, frequency, phase, offset)
            playSound(offset)
        }else if (waveType == 2) {
            generateSquareWave(amplitude, frequency,dutyCycle, phase, offset)
            playSound(offset)
        }else if(waveType == 3){
            generateRampWave(amplitude, frequency, phase, offset)
            playSound(offset)
        } else if (waveType == 4) {
            generateSawtoothWave(amplitude, frequency, phase, offset)
            playSound(offset)
        }else if (waveType == 5) {
            generateTriangularWave(amplitude, frequency, phase, offset)
            playSound(offset)
        }else if (waveType == 6) {
            generateFibonacciWave(amplitude, frequency, phase, offset)
            playSound(offset)
        }else if(waveType == 9){
            generateGoldWave(amplitude, frequency, phase, offset)
            playSound(offset)
        }
    }

    private fun stopAudioPlayback() {
        if (isPlaying) {
            isPlaying = false
            audioTrack.stop()
            audioTrack.release()
        }
    }

    fun playSound(offset: Double) {

        // Set up AudioTrack
        audioTrack = AudioTrack(
            AudioManager.STREAM_MUSIC,
            sampleRate, AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT, buffer.size,
            AudioTrack.MODE_STATIC
        )

        // Write the buffer to the track
        audioTrack.write(buffer, offset.toInt(), buffer.size)

        // Start playback
        audioTrack.play()
    }

    private fun generateSquareWave(amplitude: Double, frequency: Double, dutyCycle: Double, phase: Double, offset: Double) {
        val samplesPerPeriod = (sampleRate / frequency).toInt()
        val highSamples = (samplesPerPeriod * dutyCycle).toInt()

        for (i in 0 until durationSeconds * sampleRate) {
            val currentSample = (i + phase * sampleRate).toInt() % samplesPerPeriod
            val value = if (currentSample < highSamples) amplitude else -amplitude

            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }


    // Used to generate Sine  Waves
    private fun generateSineWave(amplitude: Double, frequency: Double, phase: Double, offset: Double){
        for (i in 0 until durationSeconds * sampleRate) {
            val angularFrequency = 2 * Math.PI * frequency
            buffer[2 * i] = (sin(angularFrequency * i / sampleRate) * amplitude).toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateSawtoothWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        for (i in 0 until durationSeconds * sampleRate) {
            val value = ((i.toDouble() / (sampleRate / frequency)) % 1.0) * amplitude
            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateTriangularWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        for (i in 0 until durationSeconds * sampleRate) {
            val value = (2 * Math.abs(((i.toDouble() / (sampleRate / frequency)) % 1.0) - 0.5) - 0.5) * 2 * amplitude
            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateRampWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        val samplesPerPeriod = (sampleRate / frequency).toInt()
        val bufferIndex = (phase * sampleRate).toInt()

        for (i in 0 until durationSeconds * sampleRate) {
            val index = (bufferIndex + i) % samplesPerPeriod
            val value = (index.toDouble() / samplesPerPeriod) * 2 * amplitude - amplitude

            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateGoldWave(amplitude: Double, frequency: Double, phase: Double, offset: Double){
        for (i in 0 until durationSeconds * sampleRate) {
            val phi = (1 + sqrt(5.0)) / 2
            val angularFrequency = 2 * Math.PI * frequency
            buffer[2 * i] = (amplitude *  (sin(angularFrequency * (i / sampleRate) + phi) + sin(angularFrequency * (i / sampleRate) * phi))).toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateFibonacciWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        // Calculate Fibonacci sequence values
        val fibonacciValues = generateFibonacciSequence(durationSeconds)

        // Scale the Fibonacci values to fit within the amplitude range
        val scaledValues = fibonacciValues.map { it.toDouble() / fibonacciValues.last() * amplitude }

        // Generate the wave based on the scaled Fibonacci values
        for (i in 0 until durationSeconds * sampleRate) {
            val index = (i + phase * sampleRate).toInt() % scaledValues.size
            buffer[2 * i] = scaledValues[index].toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    private fun generateFibonacciSequence(length: Int): List<Long> {
        val fibonacciValues = mutableListOf(0L, 1L)
        while (fibonacciValues.size < length) {
            val nextValue = fibonacciValues[fibonacciValues.size - 1] + fibonacciValues[fibonacciValues.size - 2]
            fibonacciValues.add(nextValue)
        }
        return fibonacciValues.take(length)
    }


}
