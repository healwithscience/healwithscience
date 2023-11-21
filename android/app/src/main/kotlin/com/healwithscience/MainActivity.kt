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
import kotlin.math.atan
import kotlin.math.floor
import kotlin.math.sin
import kotlin.math.sqrt
import kotlin.math.tan


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

//                    Toast.makeText(this, waveType.toString(), Toast.LENGTH_SHORT).show();

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
        val sampleRate = 5512
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

//        for (i in 0 until numSamples) {
//            val t = i.toDouble() / sampleRate
//            val value =
//                (amplitude * sin(2 * PI * frequency * t + phase) * (if (t % 1 < dutyCycle) 1 else -1) + offset).toFloat()
//            buffer[i] = (value * Short.MAX_VALUE).toInt().toShort()
//        }
        Toast.makeText(this, waveType.toString(), Toast.LENGTH_SHORT).show()
        for (i in 0 until numSamples) {
            val t = i.toDouble() / sampleRate

            val value: Float = if (waveType == 1) {
                generateSineWave(amplitude, frequency, phase, offset, t)
            } else if (waveType == 2) {
                generateSquareWave(amplitude, frequency, phase, offset, t)
            } else if (waveType == 3) {
                generateRampWave(amplitude, frequency, phase, offset, dutyCycle, t)
            } else if (waveType == 4) {
                generateSawtoothWave(amplitude, frequency, phase, offset, t)
            } else if (waveType == 5) {
                generateTriangularWave(amplitude, frequency, phase, offset, t)
            }else if (waveType == 6){
                generateGoldenWave(amplitude, frequency, phase, offset, t)
            }else if(waveType == 7){
                generateWobbleWave(amplitude, frequency, phase, offset, t)
            }else if (waveType == 8){
                generateHarmonicWave(amplitude, frequency, phase, offset, t)
            }else if (waveType == 9){
                generateFibonacciWave(amplitude, frequency)
            }
            else {
                0.0f // Default value or handle the case for an unknown waveform
            }
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

    // Used to generate Wobble  Waves
    private fun generateWobbleWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        val epsilon = 0.1 * sin(0.5 * PI * t)
        val newFrequency = frequency + epsilon
        return (amplitude * sin(2 * PI * newFrequency * t + phase)).toFloat()

    }

    // Used to generate Sine  Waves
    private fun generateSineWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        return (amplitude * sin(2 * PI * frequency * t + phase)).toFloat()
    }

    // Used to generate Square  Waves
    private fun generateSquareWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        var result = 0.0

        for (n in 1..10) { // Summing the first 10 terms (you can adjust this)
            result += (4.0 / (PI * (2 * n - 1))) * sin((2 * n - 1) * 2 * PI * frequency * t)
        }

        return (result * amplitude + offset).toFloat()
    }

    // Used to generate Sawtooth  Waves
    private fun generateSawtoothWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        var result = 0.0

        for (n in 1..10) { // Summing the first 10 terms (you can adjust this)
            result += (1.0 / n) * sin(n * 2 * PI * frequency * t)
        }

        return (((PI / 2) - 2 * result) * amplitude + offset).toFloat()
    }

    //Used to generate Triangular Waves
    private fun generateTriangularWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        val shiftedSawtooth = (t - floor(t + 0.5)).toFloat() // Absolute value of a shifted sawtooth wave

        // For a triangle wave spanning the range [-1,1]
        val triangularWave = 2 * shiftedSawtooth - 1

        return (amplitude * triangularWave + offset).toFloat()
    }

    //Used to generate Ram Waves
    private fun generateRampWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, dutyCycle: Double, t: Double): Float {
        return if (t % 1 < dutyCycle) ((2.0 / PI) * atan(tan(PI * frequency * t + phase) + offset)).toFloat() else 0.0f
    }

    //Used to generate Golden Waves
    private fun generateGoldenWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float {
        val goldenRatio = (1 + sqrt(5.0)) / 2
        val value = sin(2 * PI * frequency * t + phase) + sin(2 * PI * frequency * goldenRatio * t)

        return ( value).toFloat()
//        return (amplitude * value + offset).toFloat()
    }


    //Used to generate Golden Waves
    private fun generateHarmonicWave(amplitude: Double, frequency: Double, phase: Double, offset: Double, t: Double): Float{
        return  (amplitude * sin(2 * PI * frequency * t + phase)).toFloat()
    }
    private fun generateFibonacciWave(initialAmplitude: Double, t: Double): Float {
        // Generate the Fibonacci number at time t
        val fibonacciNumber = generateFibonacciNumber(t.toInt())

        // Calculate the amplitude using the Fibonacci number
        val amplitude = initialAmplitude * fibonacciNumber

        return amplitude.toFloat()
    }

    private fun generateFibonacciNumber(n: Int): Double {
        if (n <= 1) {
            return n.toDouble()
        }

        var a = 0.0
        var b = 1.0

        repeat(n - 1) {
            val next = a + b
            a = b
            b = next
        }

        return b
    }











/*    private fun generateSquareWave(
        amplitude: Double,
        frequency: Double,
        phase: Double,
        offset: Double,
        t: Double
    ): Float {
        val period = 1.0 / frequency
        val normalizedTime = (t + phase / (2.0 * PI)) % period / period

        return if (normalizedTime < 0.5) {
            (amplitude + offset).toFloat()
        } else {
            (-amplitude + offset).toFloat()
        }
    }*/



 /*   private fun generateSawtoothWave(
        amplitude: Double,
        frequency: Double,
        phase: Double,
        offset: Double,
        t: Double
    ): Float {
        return ((2 / PI) * atan(tan(PI * frequency * t + phase) + offset)).toFloat()
    }*/

 /*   private fun generateTriangularWave(
        amplitude: Double,
        frequency: Double,
        phase: Double,
        offset: Double,
        t: Double
    ): Float {
        return ((2 / PI) * asin(sin(2 * PI * frequency * t + phase) + offset) * amplitude).toFloat()
    }*/
}
