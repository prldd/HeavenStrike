class_name BattleAudio
extends Node

const SAMPLE_RATE := 22050
const PLAYER_COUNT := 10

var volume_step := 2
var players: Array[AudioStreamPlayer] = []
var sounds: Dictionary = {}
var next_player := 0

func _ready() -> void:
	for index in PLAYER_COUNT:
		var player := AudioStreamPlayer.new()
		player.bus = &"Master"
		add_child(player)
		players.append(player)
	_build_sounds()
	_apply_volume()

func play(event_name: String) -> void:
	if volume_step <= 0 or not sounds.has(event_name):
		return
	var player: AudioStreamPlayer = players[next_player]
	next_player = (next_player + 1) % players.size()
	player.stop()
	player.stream = sounds[event_name]
	player.pitch_scale = 1.0 if event_name == "victory" else 0.97 + randf() * 0.06
	player.play()

func cycle_volume() -> void:
	volume_step = (volume_step + 2) % 3
	_apply_volume()

func label() -> String:
	match volume_step:
		2:
			return "SOUND 100%"
		1:
			return "SOUND 50%"
		_:
			return "SOUND OFF"

func _apply_volume() -> void:
	var volume_db := -80.0 if volume_step == 0 else (-8.0 if volume_step == 1 else -1.5)
	for player in players:
		player.volume_db = volume_db

func _build_sounds() -> void:
	sounds = {
		"deploy": _tone(180.0, 0.24, 0.18, 0.08, 310.0),
		"move": _tone(115.0, 0.12, 0.24, 0.16, 155.0),
		"melee": _tone(125.0, 0.14, 0.35, 0.38, 72.0),
		"gunner": _tone(440.0, 0.16, 0.32, 0.22, 170.0),
		"mage": _tone(330.0, 0.28, 0.16, 0.06, 760.0),
		"priest": _tone(520.0, 0.32, 0.10, 0.02, 780.0),
		"hit": _tone(92.0, 0.13, 0.48, 0.46, 55.0),
		"heal": _tone(610.0, 0.34, 0.08, 0.01, 920.0),
		"status": _tone(275.0, 0.22, 0.18, 0.04, 410.0),
		"shield": _tone(720.0, 0.25, 0.22, 0.03, 390.0),
		"commander": _tone(68.0, 0.32, 0.42, 0.34, 42.0),
		"defeat": _tone(210.0, 0.42, 0.24, 0.18, 48.0),
		"victory": _victory_fanfare()
	}

func _victory_fanfare() -> AudioStreamWAV:
	var notes := [523.25, 659.25, 783.99, 1046.50]
	var note_duration := 0.19
	var final_duration := 0.68
	var duration: float = note_duration * 3.0 + final_duration
	var sample_count := int(SAMPLE_RATE * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var phases := [0.0, 0.0, 0.0]
	for index in sample_count:
		var time := float(index) / SAMPLE_RATE
		var note_index := mini(3, int(time / note_duration))
		var segment_start: float = note_duration * note_index
		var segment_duration: float = final_duration if note_index == 3 else note_duration
		var segment_progress := clampf((time - segment_start) / segment_duration, 0.0, 1.0)
		var frequency: float = notes[note_index]
		var envelope := minf(1.0, segment_progress * 10.0)
		envelope *= pow(1.0 - segment_progress, 0.42 if note_index == 3 else 0.7)
		var wave := 0.0
		var chord := [1.0, 1.25, 1.5] if note_index == 3 else [1.0, 2.0, 3.0]
		for voice in 3:
			phases[voice] += TAU * frequency * chord[voice] / SAMPLE_RATE
			wave += sin(phases[voice]) * (0.52 if voice == 0 else 0.20)
		var sample := clampi(int(wave * envelope * 14500.0), -32768, 32767)
		data.encode_s16(index * 2, sample)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream

func _tone(
	start_frequency: float,
	duration: float,
	decay: float,
	noise_mix: float,
	end_frequency: float
) -> AudioStreamWAV:
	var sample_count := maxi(1, int(SAMPLE_RATE * duration))
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var phase := 0.0
	var noise_state := 7919
	for index in sample_count:
		var progress := float(index) / float(sample_count)
		var frequency := lerpf(start_frequency, end_frequency, progress)
		phase += TAU * frequency / SAMPLE_RATE
		noise_state = int((noise_state * 1103515245 + 12345) & 0x7fffffff)
		var noise := (float(noise_state) / 1073741824.0) - 1.0
		var envelope := pow(1.0 - progress, 1.0 + decay * 5.0)
		var wave := sin(phase) * (1.0 - noise_mix) + noise * noise_mix
		var sample := clampi(int(wave * envelope * 15000.0), -32768, 32767)
		data.encode_s16(index * 2, sample)
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = data
	return stream
