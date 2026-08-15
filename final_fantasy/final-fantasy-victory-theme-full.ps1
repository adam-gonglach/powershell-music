# ============================================================
# Final Fantasy VII Victory Fanfare - PCM Audio Synth
# Generates exact-frequency PCM samples and plays them through
# the Windows audio subsystem using System.Media.SoundPlayer.
# Arrangement URL: https://musescore.com/user/79241176/scores/6421717?srsltid=AfmBOorb4o_KpNj2jB6je1GD1I1K9AsHdOqTpoR42TATjbuFqdFLxpgl
# ============================================================

# ------------------------------------------------------------
# Song / Audio Settings
# ------------------------------------------------------------

$Bpm        = 130
$SampleRate = 44100
$Volume     = 0.35       # 0.0 to 1.0
$Waveform   = "Square"   # "Sine" or "Square"

# A small attack/release envelope prevents clicks at note edges.
$AttackMs   = 4
$ReleaseMs  = 8

# Gap inserted inside each written note duration.
$ArticulationGapMs = 18

# ------------------------------------------------------------
# Note Frequencies (equal temperament, A4 = 440 Hz)
# ------------------------------------------------------------

$Notes = @{

    # Octave 3
    C3  = 130.81
    Db3 = 138.59
    D3  = 146.83
    Eb3 = 155.56
    E3  = 164.81
    F3  = 174.61
    Gb3 = 185.00
    G3  = 196.00
    Ab3 = 207.65
    A3  = 220.00
    Bb3 = 233.08
    B3  = 246.94

    # Octave 4
    C4  = 261.63
    Db4 = 277.18
    D4  = 293.67
    Eb4 = 311.13
    E4  = 329.63
    F4  = 349.23
    Gb4 = 370.00
    G4  = 392.00
    Ab4 = 415.30
    A4  = 440.00
    Bb4 = 466.1638
    B4  = 493.88

    # Octave 5
    C5  = 523.2511
    Db5 = 554.37
    D5  = 587.33
    Eb5 = 622.25
    E5  = 659.25
    F5  = 698.46
    Gb5 = 739.99
    G5  = 783.99
    Ab5 = 830.61
    A5  = 880.00
    Bb5 = 932.33
    B5  = 987.77

    # Octave 6
    C6  = 1046.50
}

# ------------------------------------------------------------
# Musical Durations
# ------------------------------------------------------------

$Quarter        = 60000.0 / $Bpm
$DottedHalf     = $Quarter * 3.0
$Half           = $Quarter * 2.0
$Whole          = $Quarter * 4.0
$Eighth         = $Quarter / 2.0
$Sixteenth      = $Quarter / 4.0
$TripletEighth  = $Quarter / 3.0
$TripleSixteenth = $Quarter / 6.0

# ------------------------------------------------------------
# Build the score first so all timing is sample-accurate.
# ------------------------------------------------------------

$Score = [System.Collections.Generic.List[object]]::new()

function Add-Note {
    param(
        [Parameter(Mandatory)]
        [string]$Note,

        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    if (-not $Notes.ContainsKey($Note)) {
        throw "Unknown note: $Note"
    }

    $Score.Add([pscustomobject]@{
        Type       = "Note"
        Note       = $Note
        Frequency  = [double]$Notes[$Note]
        DurationMs = $DurationMs
    })
}

function Add-Rest {
    param(
        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    $Score.Add([pscustomobject]@{
        Type       = "Rest"
        DurationMs = $DurationMs
    })
}

# ============================================================
# THE MELODY
# ============================================================

Add-Note C5     $TripleSixteenth
Add-Rest        $TripleSixteenth
Add-Note C5     $TripleSixteenth
Add-Rest        $TripleSixteenth
Add-Note C5     $TripleSixteenth
Add-Rest        $TripleSixteenth
Add-Note C5     $Quarter

Add-Note Ab4    $Quarter
Add-Note Bb4    $Quarter
Add-Note C5     $TripletEighth
Add-Rest        $TripletEighth
Add-Note Bb4    $TripletEighth
Add-Note C5     $DottedHalf 



# repeat section twice
for ($i = 1; $i -le 2; $i++)
{
    # measure 1 of repeat section
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note F4   $Sixteenth

    Add-Note Ab4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Ab4  $Sixteenth
    Add-Note F4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth

    # measure 2 of repeat section
    Add-Note A4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note F4   $Sixteenth

    Add-Note A4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note A4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth

    #measure 3 of repeat section, which is identical to measure 1
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note F4   $Sixteenth

    Add-Note Ab4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Ab4  $Sixteenth
    Add-Note F4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth

    #measure 4 of loop
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note E4   $Sixteenth

    Add-Note Ab4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Ab4  $Sixteenth
    Add-Note E4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    Add-Note E4  $Sixteenth

    #measure 5 of repeat section
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note F4   $Sixteenth

    Add-Note Ab4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Ab4  $Sixteenth
    Add-Note F4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note Ab4  $Sixteenth
    
    #measure 6 of repeat section which is identical to measure 2
    Add-Note A4 $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Ab4 $Sixteenth
    Add-Note F4   $Sixteenth

    Add-Note A4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note A4 $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note Bb4  $Sixteenth

    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note A4  $Sixteenth
    Add-Note F4  $Sixteenth

    #measure 7 of repeat section
    Add-Note Bb4 $Sixteenth
    Add-Note Db5  $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note Gb4   $Sixteenth

    Add-Note Bb4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note Db5  $Sixteenth

    Add-Note Bb4  $Sixteenth
    Add-Note Gb4  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Db5  $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note Gb4  $Sixteenth

    #measure 8 of repeat section which is identical to measure 7
    Add-Note Bb4 $Sixteenth
    Add-Note Db5  $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note Gb4   $Sixteenth

    Add-Note Bb4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note Db5  $Sixteenth

    Add-Note Bb4  $Sixteenth
    Add-Note Gb4  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note Db5  $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note Gb4  $Sixteenth

    #measure 9 of repeat section which is almost identical to measures 7 and 8
    #but we use D5 and G4 instead of Db5 and Gb4
    Add-Note Bb4 $Sixteenth
    Add-Note D5  $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note G4   $Sixteenth

    Add-Note Bb4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note D5  $Sixteenth

    Add-Note Bb4  $Sixteenth
    Add-Note G4  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note D5  $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note G4  $Sixteenth

    #measure 10 of repeat section, which is identical to measure 9
    Add-Note Bb4 $Sixteenth
    Add-Note D5  $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note G4   $Sixteenth

    Add-Note Bb4 $Sixteenth
    Add-Rest $Sixteenth
    Add-Note Bb4 $Sixteenth
    Add-Note D5  $Sixteenth

    Add-Note Bb4  $Sixteenth
    Add-Note G4  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note C5  $Sixteenth

    Add-Note D5  $Sixteenth
    Add-Note C5  $Sixteenth
    Add-Note Bb4  $Sixteenth
    Add-Note G4  $Sixteenth
}

# ------------------------------------------------------------
# PCM Sample Generation
# ------------------------------------------------------------

$Samples = [System.Collections.Generic.List[int16]]::new()

function Add-SilenceSamples {
    param([double]$DurationMs)

    $Count = [int][Math]::Round(($DurationMs / 1000.0) * $SampleRate)

    for ($i = 0; $i -lt $Count; $i++) {
        $Samples.Add([int16]0)
    }
}

function Add-ToneSamples {
    param(
        [double]$Frequency,
        [double]$DurationMs
    )

    $ToneDurationMs = [Math]::Max(0.0, $DurationMs - $ArticulationGapMs)
    $SampleCount    = [int][Math]::Round(($ToneDurationMs / 1000.0) * $SampleRate)

    if ($SampleCount -le 0) {
        Add-SilenceSamples $DurationMs
        return
    }

    $AttackSamples  = [int][Math]::Round(($AttackMs  / 1000.0) * $SampleRate)
    $ReleaseSamples = [int][Math]::Round(($ReleaseMs / 1000.0) * $SampleRate)

    $AttackSamples  = [Math]::Min($AttackSamples,  [int]($SampleCount / 2))
    $ReleaseSamples = [Math]::Min($ReleaseSamples, [int]($SampleCount / 2))

    $Amplitude = 32767.0 * [Math]::Max(0.0, [Math]::Min(1.0, $Volume))
    $TwoPi     = 2.0 * [Math]::PI

    for ($i = 0; $i -lt $SampleCount; $i++) {
        $Time  = $i / [double]$SampleRate
        $Phase = $TwoPi * $Frequency * $Time

        switch ($Waveform.ToLowerInvariant()) {
            "sine" {
                $Value = [Math]::Sin($Phase)
            }

            "square" {
                # Slightly soften the square wave by adding a small
                # third harmonic instead of using a mathematically
                # perfect hard-edged square. It sounds less abrasive.
                $Fundamental = [Math]::Sin($Phase)
                $Third       = [Math]::Sin(3.0 * $Phase) / 3.0
                $Value       = ($Fundamental + $Third) * 0.75
            }

            default {
                throw "Unsupported waveform '$Waveform'. Use Sine or Square."
            }
        }

        $Envelope = 1.0

        if ($AttackSamples -gt 0 -and $i -lt $AttackSamples) {
            $Envelope = $i / [double]$AttackSamples
        }
        elseif ($ReleaseSamples -gt 0 -and $i -ge ($SampleCount - $ReleaseSamples)) {
            $Envelope = ($SampleCount - 1 - $i) / [double]$ReleaseSamples
        }

        $Envelope = [Math]::Max(0.0, [Math]::Min(1.0, $Envelope))
        $PcmValue = [int][Math]::Round($Value * $Envelope * $Amplitude)
        $PcmValue = [Math]::Max([int16]::MinValue, [Math]::Min([int16]::MaxValue, $PcmValue))

        $Samples.Add([int16]$PcmValue)
    }

    if ($ArticulationGapMs -gt 0) {
        Add-SilenceSamples $ArticulationGapMs
    }
}

foreach ($Event in $Score) {
    if ($Event.Type -eq "Rest") {
        Add-SilenceSamples $Event.DurationMs
    }
    else {
        Add-ToneSamples $Event.Frequency $Event.DurationMs
    }
}

# ------------------------------------------------------------
# Build a standard mono 16-bit PCM WAV file in memory.
# ------------------------------------------------------------

$Channels      = 1
$BitsPerSample = 16
$BlockAlign    = $Channels * ($BitsPerSample / 8)
$ByteRate      = $SampleRate * $BlockAlign
$DataSize      = $Samples.Count * $BlockAlign
$RiffSize      = 36 + $DataSize

$Stream = [System.IO.MemoryStream]::new()
$Writer = [System.IO.BinaryWriter]::new($Stream)

try {
    # RIFF header
    $Writer.Write([System.Text.Encoding]::ASCII.GetBytes("RIFF"))
    $Writer.Write([int]$RiffSize)
    $Writer.Write([System.Text.Encoding]::ASCII.GetBytes("WAVE"))

    # fmt chunk
    $Writer.Write([System.Text.Encoding]::ASCII.GetBytes("fmt "))
    $Writer.Write([int]16)                  # PCM fmt chunk size
    $Writer.Write([int16]1)                 # Audio format: PCM
    $Writer.Write([int16]$Channels)
    $Writer.Write([int]$SampleRate)
    $Writer.Write([int]$ByteRate)
    $Writer.Write([int16]$BlockAlign)
    $Writer.Write([int16]$BitsPerSample)

    # data chunk
    $Writer.Write([System.Text.Encoding]::ASCII.GetBytes("data"))
    $Writer.Write([int]$DataSize)

    foreach ($Sample in $Samples) {
        $Writer.Write([int16]$Sample)
    }

    $Writer.Flush()
    $Stream.Position = 0

    # SoundPlayer uses the normal Windows wave output path.
    $Player = [System.Media.SoundPlayer]::new($Stream)
    $Player.Load()
    $Player.PlaySync()
}
finally {
    if ($null -ne $Player) {
        $Player.Dispose()
    }

    $Writer.Dispose()
    $Stream.Dispose()
}