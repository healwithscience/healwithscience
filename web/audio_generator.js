let oscillator;
let bufferSource;

function generateAudio(amplitude, frequency, phase, waveType) {
  if (waveType === 1) {
    generateSineAudio(amplitude, frequency, phase,300,22050);
  } else if (waveType === 2) {
    generateSquareAudio(amplitude, frequency, phase);
  } else if (waveType === 3) {
    generateRampWaveAudio(amplitude, frequency, phase,300,22050);
  } else if (waveType === 4) {
      generateSawAudio(amplitude, frequency, phase);
  } else if (waveType === 5) {
     generateTriangleAudio(amplitude, frequency, phase);
  } else if (waveType === 6) {
    generateFibonacciWave(amplitude, frequency, phase,300,22050);
  }else if (waveType === 7) {
    generateAndPlayHarmonicWave(amplitude, frequency, 300,22050);
  }
}


function generateSineAudio(amplitude, frequency, phase, durationSeconds, sampleRate) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const bufferSize = durationSeconds * sampleRate;
  const buffer = audioContext.createBuffer(1, bufferSize, sampleRate);
  const data = buffer.getChannelData(0);

  // Generate the sine wave samples and store in the buffer
  for (let i = 0; i < bufferSize; i++) {
    data[i] = amplitude * Math.sin(2 * Math.PI * frequency * i / sampleRate + phase);
  }

  // Create a buffer source node and set the buffer
  bufferSource = audioContext.createBufferSource();
  bufferSource.buffer = buffer;

  // Connect the buffer source to the audio context's destination
  bufferSource.connect(audioContext.destination);

  // Start playing the buffer source
  bufferSource.start();
}

function generateSquareAudio(amplitude, frequency, phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  oscillator.type = 'square'; // You can change the wave type if needed
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
//  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
}

// Used to generate Ramp Wave
function generateRampWaveAudio(amplitude, frequency, phase, durationSeconds, sampleRate) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const bufferSize = durationSeconds * sampleRate;
  const buffer = new Float32Array(bufferSize);
  const gainNode = audioContext.createGain();

  gainNode.connect(audioContext.destination);

  for (let i = 0; i < bufferSize; i++) {
    const index = i % (sampleRate / frequency);
    const value = (index / (sampleRate / frequency)) * 2 * amplitude - amplitude;
    buffer[i] = value;
  }

  bufferSource = audioContext.createBufferSource();
  const audioBuffer = audioContext.createBuffer(1, bufferSize, sampleRate);
  audioBuffer.getChannelData(0).set(buffer);

  bufferSource.buffer = audioBuffer;
  bufferSource.connect(gainNode);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
  bufferSource.detune.setValueAtTime(phase, audioContext.currentTime);

  bufferSource.start();

}

function generateSawAudio(amplitude, frequency, phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  oscillator.type = 'sawtooth'; // You can change the wave type if needed
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
}


function generateTriangleAudio(amplitude, frequency, phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  oscillator.type = 'triangle'; // You can change the wave type if needed
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
}






// Used to generate fabonnacci Waves
function generateFibonacciWave(amplitude, frequency, phase, durationSeconds,sampleRate) {

    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    // Calculate Fibonacci sequence values
    const fibonacciValues = generateFibonacciSequence(durationSeconds);

    // Scale the Fibonacci values to fit within the amplitude range
    const scaledValues = fibonacciValues.map(value => (value / fibonacciValues[fibonacciValues.length - 1]) * amplitude);

    // Create an audio buffer
    const bufferSize = durationSeconds * sampleRate;
    const buffer = audioContext.createBuffer(1, bufferSize, sampleRate);
    const data = buffer.getChannelData(0);

    // Generate the wave based on the scaled Fibonacci values
    for (let i = 0; i < bufferSize; i++) {
        const index = (i + phase * sampleRate) % scaledValues.length;
        data[i] = scaledValues[index];
    }

    // Create an audio buffer source
    bufferSource = audioContext.createBufferSource();
    bufferSource.buffer = buffer;

    // Connect the source to the destination (speakers)
    bufferSource.connect(audioContext.destination);

    // Start the audio source
    bufferSource.start();
}

function generateFibonacciSequence(length) {
    const fibonacciValues = [0, 1];
    while (fibonacciValues.length < length) {
        const nextValue = fibonacciValues[fibonacciValues.length - 1] + fibonacciValues[fibonacciValues.length - 2];
        fibonacciValues.push(nextValue);
    }
    return fibonacciValues.slice(0, length);
}




// Used to generate harmonic waves
function generateAndPlayHarmonicWave(fundamentalFrequency, amplitude, durationSeconds, sampleRate) {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    const bufferSize = durationSeconds * sampleRate;

    // Check if bufferSize is valid
    if (bufferSize <= 0) {
        console.error("Invalid buffer size");
        return;
    }

    const buffer = audioContext.createBuffer(1, bufferSize, sampleRate);

    const data = buffer.getChannelData(0);

    for (let i = 0; i < bufferSize; i++) {
        let sampleValue = 0.0;

        // Add the fundamental frequency
        sampleValue += Math.sin(2 * Math.PI * fundamentalFrequency * i / sampleRate);

        // Add the harmonics
        for (let harmonic = 2; harmonic <= 5; harmonic++) {
            const harmonicFrequency = fundamentalFrequency * harmonic;
            sampleValue += Math.sin(2 * Math.PI * harmonicFrequency * i / sampleRate) / harmonic;
        }

        // Scale the sample value by the amplitude
        sampleValue *= amplitude;

        // Store the sample value in the buffer
        data[i] = sampleValue;
    }

    bufferSource = audioContext.createBufferSource();
    bufferSource.buffer = buffer;
    bufferSource.connect(audioContext.destination);
    bufferSource.start();
}




// Used to stop audio
function stopAudio() {
  if (bufferSource) {
    bufferSource.stop();
  }
    if (oscillator) {
      oscillator.stop();
    }
}
