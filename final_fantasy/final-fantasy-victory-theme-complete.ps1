# ============================================================
# Final Fantasy VII Victory Fanfare - PCM Audio Synth
# Melody + left-hand harmony transcribed into independent tracks,
# mixed into a mono PCM WAV, and played with System.Media.SoundPlayer.
# Arrangement URL: https://musescore.com/user/79241176/scores/6421717?srsltid=AfmBOorb4o_KpNj2jB6je1GD1I1K9AsHdOqTpoR42TATjbuFqdFLxpgl
# ============================================================

# ------------------------------------------------------------
# Song / Audio Settings
# ------------------------------------------------------------

$Bpm        = 130        # Original score is marked 120; 130 preserves your current tempo.
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

    # Octave 2
    Bb2 = 116.5409

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

# ------------------------------------------------------------
# Harmony Track Helpers
# ------------------------------------------------------------

$HarmonyScore = [System.Collections.Generic.List[object]]::new()

function Add-HarmonyNote {
    param(
        [Parameter(Mandatory)]
        [string]$Note,

        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    if (-not $Notes.ContainsKey($Note)) {
        throw "Unknown harmony note: $Note"
    }

    $HarmonyScore.Add([pscustomobject]@{
        Type       = "Note"
        Note       = $Note
        Frequency  = [double]$Notes[$Note]
        DurationMs = $DurationMs
    })
}

function Add-HarmonyChord {
    param(
        [Parameter(Mandatory)]
        [string[]]$ChordNotes,

        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    $Frequencies = foreach ($Note in $ChordNotes) {
        if (-not $Notes.ContainsKey($Note)) {
            throw "Unknown harmony note: $Note"
        }

        [double]$Notes[$Note]
    }

    $HarmonyScore.Add([pscustomobject]@{
        Type        = "Chord"
        Notes       = [string[]]$ChordNotes
        Frequencies = [double[]]$Frequencies
        DurationMs  = $DurationMs
    })
}

function Add-HarmonyRest {
    param(
        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    $HarmonyScore.Add([pscustomobject]@{
        Type       = "Rest"
        DurationMs = $DurationMs
    })
}

function Add-RepeatedHarmonyChord {
    param(
        [Parameter(Mandatory)]
        [string[]]$ChordNotes,

        [Parameter(Mandatory)]
        [int]$Count,

        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    for ($i = 0; $i -lt $Count; $i++) {
        Add-HarmonyChord $ChordNotes $DurationMs
    }
}

# ============================================================
# THE MELODY
# ============================================================

# The 9/4 intro begins with a quarter-note rest.
Add-Rest $Quarter

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
    Add-Note F4  $Sixteenth
    
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

# ============================================================
# THE HARMONY / LEFT-HAND PART
# ============================================================

# Intro, 9/4.
# The first six groups are eighth-note triplets in bass clef.
Add-HarmonyRest $Quarter

# Triplet 1
Add-HarmonyNote C3 $TripletEighth
Add-HarmonyNote E3 $TripletEighth
Add-HarmonyNote G3 $TripletEighth

# Triplet 2
Add-HarmonyNote C4  $TripletEighth
Add-HarmonyNote G3  $TripletEighth
Add-HarmonyNote Eb3 $TripletEighth

# Triplet 3
Add-HarmonyNote Db3 $TripletEighth
Add-HarmonyNote Eb3 $TripletEighth
Add-HarmonyNote Ab3 $TripletEighth

# Triplet 4
Add-HarmonyNote Bb2 $TripletEighth
Add-HarmonyNote D3  $TripletEighth
Add-HarmonyNote F3  $TripletEighth

# Triplet 5
Add-HarmonyNote F3  $TripletEighth
Add-HarmonyNote Ab3 $TripletEighth
Add-HarmonyNote Bb3 $TripletEighth

# Triplet 6
Add-HarmonyNote Db3 $TripletEighth
Add-HarmonyNote F3  $TripletEighth
Add-HarmonyNote A3  $TripletEighth

# Final eight-note run is written under 8va in the bass staff.
# These are the sounding pitches. The fourth written note is C#,
# represented here enharmonically as Db because the note table uses flats.
Add-HarmonyNote C5  $Sixteenth
Add-HarmonyNote Ab4 $Sixteenth
Add-HarmonyNote F4  $Sixteenth
Add-HarmonyNote Db4 $Sixteenth
Add-HarmonyNote C4  $Sixteenth
Add-HarmonyNote Ab3 $Sixteenth
Add-HarmonyNote F3  $Sixteenth
Add-HarmonyNote C3  $Sixteenth

# Main 4/4 section.
# The first six measures use eight staccato eighth-note chords per measure.
$DHalfDim7      = @("D4",  "F4", "Ab4", "C5")
$Dm7            = @("D4",  "F4", "A4",  "C5")
$ChromaticChord = @("Db4", "E4", "A4",  "C5")
$Ebm7           = @("Eb4", "Gb4", "Bb4", "Db5")

for ($i = 1; $i -le 2; $i++) {

    for ($first = 1; $first -le 8; $first++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }

    for ($second = 1; $second -le 8; $second++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }

    for ($third = 1; $third -le 8; $third++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }

    for ($fourth = 1; $fourth -le 8; $fourth++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }

    for ($fifth = 1; $fifth -le 8; $fifth++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }
    
    for ($sixth = 1; $sixth -le 8; $sixth++)
    {
        Add-HarmonyChord $DHalfDim7 $Sixteenth
        Add-HarmonyRest        $Sixteenth
    }

    # # Repeat measure 1 / score measure 2
    # Add-RepeatedHarmonyChord $DHalfDim7 8 $Sixteenth

    # # Repeat measure 2 / score measure 3
    # Add-RepeatedHarmonyChord $Dm7 8 $Sixteenth

    # # Repeat measure 3 / score measure 4
    # Add-RepeatedHarmonyChord $DHalfDim7 8 $Sixteenth

    # # Repeat measure 4 / score measure 5
    # Add-RepeatedHarmonyChord $ChromaticChord 8 $Sixteenth

    # # Repeat measure 5 / score measure 6
    # Add-RepeatedHarmonyChord $DHalfDim7 8 $Sixteenth

    # # Repeat measure 6 / score measure 7
    # Add-RepeatedHarmonyChord $Dm7 8 $Sixteenth

    # Repeat measures 7-10 / score measures 8-11.
    # The Ebm7 chord is tied across all four measures, so render it
    # as one continuous event rather than re-attacking it.
    Add-HarmonyChord $Ebm7 ($Whole * 4.0)
}


# ------------------------------------------------------------
# PCM Sample Generation / Track Mixing
# ------------------------------------------------------------

function Render-Track {
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[object]]$Track
    )

    $TotalMs = 0.0
    foreach ($Event in $Track) {
        $TotalMs += [double]$Event.DurationMs
    }

    $TotalSamples = [int][Math]::Round(($TotalMs / 1000.0) * $SampleRate)
    $Buffer = [double[]]::new($TotalSamples)

    $ElapsedMs = 0.0
    $TwoPi = 2.0 * [Math]::PI
    $UseSine = $Waveform.Equals("Sine", [System.StringComparison]::OrdinalIgnoreCase)
    $UseSquare = $Waveform.Equals("Square", [System.StringComparison]::OrdinalIgnoreCase)

    if (-not $UseSine -and -not $UseSquare) {
        throw "Unsupported waveform '$Waveform'. Use Sine or Square."
    }

    foreach ($Event in $Track) {

        # Derive every boundary from absolute elapsed time. This avoids
        # accumulating rounding error when the tracks use different rhythms.
        $StartSample = [int][Math]::Round(($ElapsedMs / 1000.0) * $SampleRate)
        $ElapsedMs += [double]$Event.DurationMs
        $EndSample = [int][Math]::Round(($ElapsedMs / 1000.0) * $SampleRate)

        $EventSampleCount = $EndSample - $StartSample

        if ($Event.Type -eq "Rest" -or $EventSampleCount -le 0) {
            continue
        }

        $GapSamples = [int][Math]::Round(($ArticulationGapMs / 1000.0) * $SampleRate)
        $ToneSampleCount = [Math]::Max(0, $EventSampleCount - $GapSamples)

        if ($ToneSampleCount -le 0) {
            continue
        }

        $AttackSamples = [int][Math]::Round(($AttackMs / 1000.0) * $SampleRate)
        $ReleaseSamples = [int][Math]::Round(($ReleaseMs / 1000.0) * $SampleRate)

        $AttackSamples = [Math]::Min($AttackSamples, [int]($ToneSampleCount / 2))
        $ReleaseSamples = [Math]::Min($ReleaseSamples, [int]($ToneSampleCount / 2))

        if ($Event.Type -eq "Chord") {
            [double[]]$Frequencies = $Event.Frequencies
        }
        else {
            [double[]]$Frequencies = @([double]$Event.Frequency)
        }

        for ($j = 0; $j -lt $ToneSampleCount; $j++) {

            $Time = $j / [double]$SampleRate
            $Value = 0.0

            foreach ($Frequency in $Frequencies) {

                $Phase = $TwoPi * $Frequency * $Time

                if ($UseSine) {
                    $Voice = [Math]::Sin($Phase)
                }
                else {
                    # Softened square wave: fundamental + third harmonic.
                    $Fundamental = [Math]::Sin($Phase)
                    $Third       = [Math]::Sin(3.0 * $Phase) / 3.0
                    $Voice       = ($Fundamental + $Third) * 0.75
                }

                $Value += $Voice
            }

            # Normalize chords so four simultaneous voices do not
            # automatically produce four times the signal level.
            $Value /= [double]$Frequencies.Count

            $Envelope = 1.0

            if ($AttackSamples -gt 0 -and $j -lt $AttackSamples) {
                $Envelope = $j / [double]$AttackSamples
            }
            elseif ($ReleaseSamples -gt 0 -and $j -ge ($ToneSampleCount - $ReleaseSamples)) {
                $Envelope = ($ToneSampleCount - 1 - $j) / [double]$ReleaseSamples
            }

            $Envelope = [Math]::Max(0.0, [Math]::Min(1.0, $Envelope))
            $Buffer[$StartSample + $j] = $Value * $Envelope
        }
    }

    Write-Output -NoEnumerate $Buffer
}

$MelodySamples  = Render-Track $Score
$HarmonySamples = Render-Track $HarmonyScore

if ($MelodySamples.Length -ne $HarmonySamples.Length) {
    throw @"
Track lengths do not match.

Melody:  $($MelodySamples.Length) samples
Harmony: $($HarmonySamples.Length) samples
"@
}

# Keep the melody slightly forward in the mix.
$MelodyGain  = 1.00
$HarmonyGain = 0.70
$GainSum     = $MelodyGain + $HarmonyGain

$Samples = [System.Collections.Generic.List[int16]]::new($MelodySamples.Length)
$Amplitude = 32767.0 * [Math]::Max(0.0, [Math]::Min(1.0, $Volume))

for ($i = 0; $i -lt $MelodySamples.Length; $i++) {

    $Mixed = (
        ($MelodySamples[$i]  * $MelodyGain) +
        ($HarmonySamples[$i] * $HarmonyGain)
    ) / $GainSum

    $PcmValue = [int][Math]::Round($Mixed * $Amplitude)
    $PcmValue = [Math]::Max([int16]::MinValue, [Math]::Min([int16]::MaxValue, $PcmValue))

    $Samples.Add([int16]$PcmValue)
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