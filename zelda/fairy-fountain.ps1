# ============================================================
# Legned of Zelda: Fairy Fountain - PCM Audio Synth
# Melody + left-hand harmony transcribed into independent tracks,
# mixed into a mono PCM WAV, and played with System.Media.SoundPlayer.
# Arrangement URL: https://www.ninsheetmusic.org/download/pdf/1477
# ============================================================

# ------------------------------------------------------------
# Song / Audio Settings
# ------------------------------------------------------------

$Bpm        = 80        # Original score is marked 120
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

    # shouldn't need these notes
    # # Octave 0
    # F0  = 21.8268
    # G0  = 24.4997
    # A0  = 27.5000
    # Bb0 = 29.1352

    # # Octave 1
    # C1  = 32.7032
    # D1  = 36.7081
    # E1  = 41.2034
    # F1  = 43.6535
    # G1  = 48.9994
    # A1  = 55.0000
    # Bb1 = 58.2705

    # Octave 2
    C2  = 65.4064
    D2  = 73.4162
    E2  = 82.4069
    F2  = 87.3071
    G2  = 97.9989
    A2  = 110.0000
    Bb2 = 116.5409

    # Octave 3
    C3  = 130.8128
    D3  = 146.8324
    E3  = 164.8138
    F3  = 174.6141
    G3  = 195.9977
    A3  = 220.0000
    Bb3 = 233.0819

    # Octave 4
    C4  = 261.6256
    D4  = 293.6648
    Eb4 = 311.13
    E4  = 329.6276
    F4  = 349.2282
    G4  = 391.9954
    A4  = 440.0000
    Bb4 = 466.1638

    # Octave 5
    C5  = 523.2511
    D5  = 587.3295
    E5  = 659.2551
    F5  = 698.4565
    Fs5 = 739.99 
    G5  = 783.9909
    A5  = 880.0000
    Bb5 = 932.3275

    # Octave 6
    C6  = 1046.5023
    Cs6 =  1108.73 
    D6  = 1174.6591
    Ds6 = 1244.51
    Eb6 = 1244.51
    E6  = 1318.5102
    F6  = 1396.9129
    Fs6 = 1479.98 
    G6  = 1567.9817
    Gs6 = 1661.22 
    A6  = 1760.0000
    Bb6 = 1864.6550

    # Octave 7
    C7  = 2093.0045
    D7  = 2349.3181
    E7  = 2637.0205
    F7  = 2793.8259
    G7  = 3135.9635
    A7  = 3520.0000
    Bb7 = 3729.3101

    # Octave 8
    C8  = 4186.0090
    D8  = 4698.6363
    E8  = 5274.0409
    F8  = 5587.6517
}

# opening chords
$Em7b5       = @("E3",  "G3",  "Bb3", "D4")
$Em7b5_G     = @("G3",  "Bb3", "D4",  "E4")
$Em7b5_Bb    = @("Bb3", "D4",  "E4",  "G4")
$Em7b5_D     = @("D4",  "E4",  "G4",  "Bb4")
$Em7b5_Octave = @("E4", "G4",  "Bb4", "D5")
$Em7b5_G_Octave = @("G4", "Bb4", "D5", "E5")
# ------------------------------------------------------------
# Musical Durations
# ------------------------------------------------------------
# standard note lengths
$Quarter        = 60000.0 / $Bpm
$DottedHalf     = $Quarter * 3.0
$Half           = $Quarter * 2.0
$TripleQuarter = $Half / 3.0
$Whole          = $Quarter * 4.0
$Eighth         = $Quarter / 2.0
$Sixteenth      = $Quarter / 4.0
$TripletEighth  = $Quarter / 3.0
$TripleSixteenth = $Quarter / 6.0
$ThirtySecond  =    $Quarter / 8.0

# ------------------------------------------------------------
# Build the score first so all timing is sample-accurate.
# ------------------------------------------------------------

$Score = [System.Collections.Generic.List[object]]::new()

function Add-Meolody-Note {
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

function Add-Melody-Chord {
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

    $Score.Add([pscustomobject]@{
        Type        = "Chord"
        Notes       = [string[]]$ChordNotes
        Frequencies = [double[]]$Frequencies
        DurationMs  = $DurationMs
    })
}

function Add-Melody-Rest {
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

function Add-Harmony-Note {
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

function Add-Harmony-Chord {
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

function Add-Harmony-Rest {
    param(
        [Parameter(Mandatory)]
        [double]$DurationMs
    )

    $HarmonyScore.Add([pscustomobject]@{
        Type       = "Rest"
        DurationMs = $DurationMs
    })
}

Write-Host "Building Melody..."
# ============================================================
# THE MELODY
# ============================================================

Add-Melody-Chord $Em7b5 $TripleQuarter
Add-Melody-Chord $Em7b5_G $TripleQuarter
Add-Melody-Chord $Em7b5_Bb $TripleQuarter
Add-Melody-Chord $Em7b5_D $TripleQuarter
Add-Melody-Chord $Em7b5_Octave $TripleQuarter
Add-Melody-Chord $Em7b5_G_Octave $TripleQuarter

# repeat section twice
for ($i = 1; $i -le 2; $i++)
{
    # measure 1
    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note Fs6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    # measure 2

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note C5 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth

    Add-Meolody-Note F6 $Sixteenth
    Add-Meolody-Note C5 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth

    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note C5 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth

    Add-Meolody-Note F6 $Sixteenth
    Add-Meolody-Note C5 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth

    # measure 3

    Add-Meolody-Note F6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note Ds6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    # measure 4

    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth
    Add-Meolody-Note D5 $Sixteenth

    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth
    Add-Meolody-Note D5 $Sixteenth

    Add-Meolody-Note Cs6 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth
    Add-Meolody-Note D5 $Sixteenth

    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note A5 $Sixteenth
    Add-Meolody-Note F5 $Sixteenth
    Add-Meolody-Note D5 $Sixteenth

    # measure 5 which is identical to measure 1

    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note Fs6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    # measure 6
    Add-Meolody-Note Bb6 $Sixteenth
    Add-Meolody-Note Eb6 $Sixteenth
    Add-Meolody-Note C6 $Sixteenth
    Add-Meolody-Note Fs5 $Sixteenth

    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note Eb6 $Sixteenth
    Add-Meolody-Note C6 $Sixteenth
    Add-Meolody-Note Fs5 $Sixteenth

    Add-Meolody-Note Gs6 $Sixteenth
    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note C6 $Sixteenth
    Add-Meolody-Note Fs5 $Sixteenth

    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note Eb6 $Sixteenth
    Add-Meolody-Note C6 $Sixteenth
    Add-Meolody-Note Fs5 $Sixteenth

    # measure 7

    Add-Meolody-Note C7 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note Bb6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    Add-Meolody-Note Bb6 $Sixteenth
    Add-Meolody-Note D6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth

    # measure 8

    Add-Meolody-Note A6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note G6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note F6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

    Add-Meolody-Note E6 $Sixteenth
    Add-Meolody-Note Bb5 $Sixteenth
    Add-Meolody-Note G5 $Sixteenth
    Add-Meolody-Note E5 $Sixteenth

}

Write-Host "Done Building Melody"


Write-Host "Building Harmony..."
# ============================================================
# THE HARMONY / LEFT-HAND PART
# ============================================================

Add-Harmony-Note C3 $TripleQuarter
Add-Harmony-Note E3 $TripleQuarter
Add-Harmony-Note G3 $TripleQuarter
Add-Harmony-Note Bb3 $TripleQuarter
Add-Harmony-Note D4 $TripleQuarter
Add-Harmony-Note E4 $TripleQuarter

# repeat section twice
for ($i = 1; $i -le 2; $i++) 
{
    # measure 1
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note A3 ($Sixteenth + $Quarter + $Sixteenth)

    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth

    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth

    # measure 2
    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note F3 ($Sixteenth + $Quarter)

    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note F3 $Sixteenth

    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note F3 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth

    # measure 3
    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note F3 ($Sixteenth + $Quarter)

    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note F3 $Sixteenth
    Add-Harmony-Note E3 $Sixteenth

    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note E3 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth

    # measure 4
    Add-Harmony-Note F2 $Sixteenth
    Add-Harmony-Note F2 $Sixteenth
    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note E3 ($Sixteenth + $Quarter)

    Add-Harmony-Note F2 $Sixteenth
    Add-Harmony-Note F2 $Sixteenth
    Add-Harmony-Note E3 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth

    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note F3 $Sixteenth
    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth

    # measure 5
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note A3 ($Sixteenth + $Quarter)

    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth

    Add-Harmony-Note D4 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth

    # measure 6  
    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note A2 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note C4 ($Sixteenth + $Quarter)

    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth

    Add-Harmony-Note Eb4 $Sixteenth
    Add-Harmony-Note D4 $Sixteenth
    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth

    # measure 7
    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth
    Add-Harmony-Note Bb3 ($Sixteenth + $Quarter)

    Add-Harmony-Note G2 $Sixteenth
    Add-Harmony-Note Bb2 $Sixteenth
    Add-Harmony-Note Bb3 $Sixteenth
    Add-Harmony-Note A3 $Sixteenth

    Add-Harmony-Note C4 $Sixteenth
    Add-Harmony-Note Bb3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note D3 $Sixteenth

    # measure 8
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth
    Add-Harmony-Note Bb3 ($Sixteenth + $Quarter)

    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note C3 $Sixteenth
    Add-Harmony-Note Bb3 $Sixteenth
    Add-Harmony-Note G3 $Sixteenth

    Add-Harmony-Note E4 $Sixteenth
    Add-Harmony-Note D4 $Sixteenth
    Add-Harmony-Note G4 $Sixteenth
    Add-Harmony-Note E4 $Sixteenth
}

Write-Host "Done Building Harmony"

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

Write-Host "Rendering Melody Track"
$MelodySamples  = Render-Track $Score

Write-Host "Rendering Harmony Track"
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