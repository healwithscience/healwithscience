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
        }else if (waveType == 7) {
            generateHarmonicWave(amplitude, frequency,dutyCycle, phase)
            playSound(offset)
        }
        else if(waveType == 8){
            generateHSquareWave(amplitude, frequency,dutyCycle, phase, offset)
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

    //Used to generate Saw Tooth Waves
    private fun generateSawtoothWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        for (i in 0 until durationSeconds * sampleRate) {
            val value = ((i.toDouble() / (sampleRate / frequency)) % 1.0) * amplitude
            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    //Used to generate Triangle Wave
    private fun generateTriangularWave(amplitude: Double, frequency: Double, phase: Double, offset: Double) {
        for (i in 0 until durationSeconds * sampleRate) {
            val value = (2 * Math.abs(((i.toDouble() / (sampleRate / frequency)) % 1.0) - 0.5) - 0.5) * 2 * amplitude
            buffer[2 * i] = value.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    //Used to generate Ramp Wafe
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

    //Used to generate Fibonacci Wave
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

    private fun generateHarmonicWave(fundamentalFrequency: Double, amplitude: Double, offset: Double, phase: Double, ) {
        for (i in 0 until durationSeconds * sampleRate) {
            var sampleValue = 0.0

            // Add the fundamental frequency
            sampleValue += sin(2 * Math.PI * fundamentalFrequency * i / sampleRate)

            // Add the harmonics
            for (harmonic in 2..5) {
                val harmonicFrequency = fundamentalFrequency * harmonic
                sampleValue += sin(2 * Math.PI * harmonicFrequency * i / sampleRate) / harmonic
            }

            // Scale the sample value by the amplitude
            sampleValue *= amplitude

            // Store the sample value in the buffer
            buffer[2 * i] = sampleValue.toInt().toByte()
            buffer[2 * i + 1] = buffer[2 * i]
        }
    }

    //Used to generate HSquare
    private fun generateHSquareWave(amplitude: Double, frequency: Double, dutyCycle: Double, phase: Double, offset: Double) {
        generateSquareWave(amplitude, frequency, dutyCycle, phase, offset)

        // Get spike height and width dynamically
        val (spikeHeight, spikeWidth) = getSpikeHeightAndWidth(amplitude, frequency, dutyCycle)

        // Add spikes to the leading and trailing edges
        val samplesPerPeriod = (sampleRate / frequency).toInt()
        for (i in 0 until durationSeconds * sampleRate) {
            val currentSample = (i + phase * sampleRate).toInt() % samplesPerPeriod

            // Check if the wave is on the leading or trailing edge
            if (currentSample < spikeWidth * samplesPerPeriod || currentSample > (dutyCycle - spikeWidth) * samplesPerPeriod) {
                // Add the spike height to the amplitude
                buffer[2 * i] = (amplitude + spikeHeight).toInt().toByte()
            }
        }
    }



    private fun getSpikeHeightAndWidth(amplitude: Double, frequency: Double, dutyCycle: Double): Pair<Double, Double> {
        // Generate a random fraction between 0 and 1 for the spike height
        val spikeHeightFraction = Math.random()

        // Calculate the spike height by multiplying the fraction by the amplitude
        val spikeHeight = spikeHeightFraction * amplitude

        // Generate a random fraction between 0 and 1 for the spike width
        val spikeWidthFraction = Math.random()

        // Calculate the period by dividing 1 by the frequency
        val period = 1 / frequency

        // Calculate the spike width by multiplying the fraction by the period
        var spikeWidth = spikeWidthFraction * period

        // Check if the spike width is greater than the duty cycle divided by the frequency
        if (spikeWidth > dutyCycle / frequency) {
            // Reduce the spike width to the duty cycle divided by the frequency
            spikeWidth = dutyCycle / frequency
        }

        // Return the spike height and width as a pair
        return Pair(spikeHeight, spikeWidth)
    }


}
