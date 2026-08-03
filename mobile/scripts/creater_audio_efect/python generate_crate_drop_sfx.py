import math
import random

import numpy as np
import soundfile as sf
from scipy.signal import butter, lfilter

# =====================================================
# Config
# =====================================================

SR = 44100
DURATION = 1.5

MASTER_VOLUME = 0.85

np.random.seed(1)
random.seed(1)


# =====================================================
# Helpers
# =====================================================

def time_array(duration):
    return np.linspace(
        0,
        duration,
        int(duration * SR),
        endpoint=False,
    )


def normalize(x):

    peak = np.max(np.abs(x))

    if peak == 0:
        return x

    return x / peak


def envelope(signal, attack=0.01, release=0.05):

    n = len(signal)

    env = np.ones(n)

    attack_len = int(attack * SR)
    release_len = int(release * SR)

    if attack_len > 0:
        env[:attack_len] = np.linspace(
            0,
            1,
            attack_len
        )

    if release_len > 0:
        env[-release_len:] = np.linspace(
            1,
            0,
            release_len
        )

    return signal * env


# =====================================================
# Filter
# =====================================================

def lowpass(data, cutoff):

    b, a = butter(
        3,
        cutoff / (SR / 2),
        btype="low"
    )

    return lfilter(b, a, data)


def highpass(data, cutoff):

    b, a = butter(
        3,
        cutoff / (SR / 2),
        btype="high"
    )

    return lfilter(b, a, data)


# =====================================================
# Oscillator
# =====================================================

def sine(freq, duration):

    t = time_array(duration)

    return np.sin(
        2 * np.pi * freq * t
    )


def square(freq, duration):

    t = time_array(duration)

    return np.sign(
        np.sin(
            2 * np.pi * freq * t
        )
    )


def saw(freq, duration):

    t = time_array(duration)

    return 2 * (
        freq * t
        - np.floor(
            0.5 + freq * t
        )
    )


def noise(duration):

    return np.random.uniform(
        -1,
        1,
        int(duration * SR)
    )
# =====================================================
# Airplane
# =====================================================

def airplane_engine(duration=0.5):

    t = time_array(duration)

    base = np.sin(2*np.pi*120*t)

    harmonic1 = 0.45*np.sin(2*np.pi*240*t)

    harmonic2 = 0.25*np.sin(2*np.pi*360*t)

    harmonic3 = 0.15*np.sin(2*np.pi*480*t)

    rumble = 0.18*np.sin(
        2*np.pi*18*t
    )

    vibrato = 1 + 0.03*np.sin(
        2*np.pi*8*t
    )

    engine = (
                     base +
                     harmonic1 +
                     harmonic2 +
                     harmonic3
             ) * vibrato

    engine += rumble

    engine = lowpass(engine, 1800)

    engine = envelope(
        engine,
        attack=0.03,
        release=0.12
    )

    return normalize(engine) * 0.35


# =====================================================
# Wind
# =====================================================

def wind(duration=0.5):

    w = noise(duration)

    w = highpass(w, 1200)

    w = lowpass(w, 7000)

    lfo = np.sin(
        2*np.pi*2*time_array(duration)
    )

    w *= 0.7 + 0.3*lfo

    w = envelope(
        w,
        attack=0.02,
        release=0.08
    )

    return normalize(w) * 0.18


# =====================================================
# Drop
# =====================================================

def drop(duration=0.08):

    t = time_array(duration)

    freq = np.linspace(
        1200,
        250,
        len(t)
    )

    phase = np.cumsum(
        2*np.pi*freq/SR
    )

    snd = np.sin(phase)

    snd = envelope(
        snd,
        attack=0.002,
        release=0.06
    )

    return normalize(snd) * 0.28


# =====================================================
# Landing
# =====================================================

def landing(duration=0.18):

    n = noise(duration)

    n = lowpass(n, 350)

    impact = np.sin(
        2*np.pi*90*time_array(duration)
    )

    snd = impact*0.5 + n*0.6

    snd = envelope(
        snd,
        attack=0.001,
        release=0.14
    )

    return normalize(snd) * 0.45
# =====================================================
# Shake Box
# =====================================================

def shake(duration=0.30):

    t = time_array(duration)

    snd = np.zeros(len(t))

    # 5 cú rung
    hits = [
        (0.02, 260),
        (0.08, 230),
        (0.14, 270),
        (0.20, 240),
        (0.26, 260),
    ]

    for hit_time, freq in hits:

        start = int(hit_time * SR)

        length = int(0.05 * SR)

        if start + length >= len(snd):
            continue

        tt = np.linspace(
            0,
            0.05,
            length,
            endpoint=False
        )

        pulse = (
                np.sin(2*np.pi*freq*tt)
                + 0.4*noise(0.05)
        )

        pulse = lowpass(
            pulse,
            900
        )

        pulse = envelope(
            pulse,
            attack=0.001,
            release=0.04
        )

        snd[start:start+length] += pulse

    return normalize(snd) * 0.40


# =====================================================
# Open Box
# =====================================================

def box_open(duration=0.20):

    t = time_array(duration)

    click = np.zeros(len(t))

    click[:400] = np.sin(
        2*np.pi*1800*np.linspace(
            0,
            400/SR,
            400,
            endpoint=False
        )
    )

    pop = np.sin(
        2*np.pi*np.linspace(
            800,
            250,
            len(t)
        ).cumsum()/SR
    )

    pop *= np.exp(-6*t)

    snd = click*0.35 + pop

    snd = envelope(
        snd,
        attack=0.001,
        release=0.12
    )

    return normalize(snd) * 0.42


# =====================================================
# Sparkle
# =====================================================

def sparkle(duration=0.40):

    snd = np.zeros(
        int(duration*SR)
    )

    count = 35

    for _ in range(count):

        pos = random.uniform(
            0,
            duration-0.03
        )

        freq = random.randint(
            1800,
            5200
        )

        start = int(pos*SR)

        length = int(0.03*SR)

        tt = np.linspace(
            0,
            0.03,
            length,
            endpoint=False
        )

        spark = np.sin(
            2*np.pi*freq*tt
        )

        spark *= np.exp(-35*tt)

        end = min(
            start+length,
            len(snd)
        )

        snd[start:end] += spark[:end-start]

    snd = highpass(
        snd,
        1500
    )

    return normalize(snd) * 0.28


# =====================================================
# Reward Ding
# =====================================================

def reward(duration=0.35):

    t = time_array(duration)

    note1 = np.sin(
        2*np.pi*880*t
    )

    note2 = np.sin(
        2*np.pi*1320*t
    )

    note3 = np.sin(
        2*np.pi*1760*t
    )

    bell = (
            note1*0.6
            + note2*0.3
            + note3*0.15
    )

    bell *= np.exp(-5*t)

    bell = envelope(
        bell,
        attack=0.002,
        release=0.20
    )

    return normalize(bell) * 0.45

# =====================================================
# Timeline Mixer
# =====================================================

def mix(canvas, sound, position):

    start = int(position * SR)

    if start >= len(canvas):
        return

    end = min(
        start + len(sound),
        len(canvas)
    )

    canvas[start:end] += sound[:end-start]


# =====================================================
# Simple Limiter
# =====================================================

def limiter(x, threshold=0.95):

    peak = np.max(np.abs(x))

    if peak <= threshold:
        return x

    return x * (threshold / peak)


# =====================================================
# Fade
# =====================================================

def fade_in_out(
        x,
        fade_in=0.01,
        fade_out=0.08
):

    x = envelope(
        x,
        attack=fade_in,
        release=fade_out
    )

    return x


# =====================================================
# Build SFX
# =====================================================

def build():

    canvas = np.zeros(
        int(DURATION * SR)
    )

    # ---------------------------------------
    # Plane Fly
    # ---------------------------------------

    mix(
        canvas,
        airplane_engine(0.50),
        0.00
    )

    mix(
        canvas,
        wind(0.50),
        0.00
    )

    # ---------------------------------------
    # Drop
    # ---------------------------------------

    mix(
        canvas,
        drop(),
        0.44
    )

    # ---------------------------------------
    # Landing
    # ---------------------------------------

    mix(
        canvas,
        landing(),
        0.54
    )

    # ---------------------------------------
    # Shake
    # ---------------------------------------

    mix(
        canvas,
        shake(),
        0.60
    )

    # ---------------------------------------
    # Open
    # ---------------------------------------

    mix(
        canvas,
        box_open(),
        0.93
    )

    # ---------------------------------------
    # Sparkles
    # ---------------------------------------

    mix(
        canvas,
        sparkle(),
        1.02
    )

    # ---------------------------------------
    # Reward
    # ---------------------------------------

    mix(
        canvas,
        reward(),
        1.18
    )

    canvas = fade_in_out(canvas)

    canvas = limiter(canvas)

    canvas = normalize(canvas)

    canvas *= MASTER_VOLUME

    return canvas.astype(np.float32)


# =====================================================
# Main
# =====================================================

if __name__ == "__main__":

    audio = build()

    sf.write(
        "crate_drop.wav",
        audio,
        SR
    )

    print("Done!")
    print("Output: crate_drop.wav")