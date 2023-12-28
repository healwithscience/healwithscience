let oscillator;

function generateAudio(amplitude, frequency, phase, waveType) {
  if (waveType === 1) {
    generateSineAudio(amplitude, frequency, phase);
  } else if (waveType === 2) {
    generateSquareAudio(amplitude, frequency, phase);
  } else if (waveType === 3) {
    generateSawAudio(amplitude, frequency, phase);
  } else if (waveType === 4) {
    generateSquareAudio(amplitude, frequency, phase);
  } else if (waveType === 5) {
    generateTriangleAudio(amplitude, frequency, phase);
  } else if (waveType === 6) {
    generateSawAudio(amplitude, frequency, phase);
  }else if (waveType === 7) {
    generateHarmonicWaveAudio(amplitude, frequency, phase);
  }
}



function generateSineAudio(amplitude, frequency, phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  oscillator.type = 'sine'; // You can change the wave type if needed
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
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
  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
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


function generateRampWaveAudio(amplitude, frequency, phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const oscillator = audioContext.createOscillator();
  const gainNode = audioContext.createGain();

  oscillator.connect(gainNode);
  gainNode.connect(audioContext.destination);

  // Use 'custom' oscillator type
  const real = new Float32Array([0, 1]); // Represents a ramp waveform
  const imag = new Float32Array([0, 0]);
  const wave = audioContext.createPeriodicWave(real, imag);
  oscillator.setPeriodicWave(wave);

  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime);

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the phase using the detune parameter
  oscillator.detune.setValueAtTime(phase, audioContext.currentTime);

  oscillator.start();
}



function generateFibonacciWaveAudio(amplitude, baseFrequency) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const gainNode = audioContext.createGain();
  gainNode.connect(audioContext.destination);

  oscillator = audioContext.createOscillator();
  oscillator.connect(gainNode);

  // Set the oscillator type to 'sine'
  oscillator.type = 'sine';

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the initial frequency
  oscillator.frequency.setValueAtTime(baseFrequency, audioContext.currentTime);

  // Start the oscillator
  oscillator.start(audioContext.currentTime);

  // Generate sound based on Fibonacci sequence continuously
  generateFibonacciSound(baseFrequency, audioContext);
}

function generateFibonacciSound(baseFrequency, audioContext) {
  const fibonacciNumbers = [1, 1];
  let currentIndex = 2;

  function updateFrequency() {
    // Calculate the next Fibonacci number
    const nextFibonacci = fibonacciNumbers[currentIndex - 1] + fibonacciNumbers[currentIndex - 2];
    fibonacciNumbers.push(nextFibonacci);

    // Update the oscillator frequency based on the Fibonacci number
    oscillator.frequency.setValueAtTime(baseFrequency + nextFibonacci, audioContext.currentTime);

    // Increment the index for the next Fibonacci number
    currentIndex++;

    // Schedule the next update after a short time
    setTimeout(updateFrequency, 100);
  }

  // Start the recursive update
  updateFrequency();
}


function generateHarmonicWaveAudio(amplitude, baseFrequency,phase) {
  const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const gainNode = audioContext.createGain();
  gainNode.connect(audioContext.destination);

  oscillator = audioContext.createOscillator();
  oscillator.connect(gainNode);

  // Set the oscillator type to 'sine'
  oscillator.type = 'sine';

  // Set the amplitude using the gain node
  gainNode.gain.setValueAtTime(amplitude, audioContext.currentTime);

  // Set the initial frequency
  oscillator.frequency.setValueAtTime(baseFrequency, audioContext.currentTime);

  // Start the oscillator
  oscillator.start(audioContext.currentTime);

  // Generate sound based on harmonic series
  generateHarmonicSound(baseFrequency, 5, audioContext);
}

function generateHarmonicSound(baseFrequency, numHarmonics, audioContext) {
  let currentHarmonic = 1;

  function updateFrequency() {
    // Update the oscillator frequency based on the current harmonic
    const harmonicFrequency = baseFrequency * currentHarmonic;
    oscillator.frequency.setValueAtTime(harmonicFrequency, audioContext.currentTime);

    // Increment the harmonic for the next iteration
    currentHarmonic++;

    // Check if we've reached the desired number of harmonics
    if (currentHarmonic <= numHarmonics) {
      // Schedule the next update after a short time
      setTimeout(updateFrequency, 100);
    } else {

    }
  }

  // Start the recursive update
  updateFrequency();
}









function stopAudio() {
  if (oscillator) {
    oscillator.stop();
  }
}