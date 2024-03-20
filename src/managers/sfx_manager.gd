extends Node

@onready var audio_players_list = get_children()

const DEFAULT_SOUND_FX_VOLUME: float = -6.0

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	_rng.randomize()

func play_sfx(sound_file: AudioStream, pitch_range: float = 0.0, pitch: float = 1.0, volume: float = DEFAULT_SOUND_FX_VOLUME):
	for i in audio_players_list:
		if not i.playing:
			i.stream = sound_file
			i.volume_db = volume
			i.pitch_scale = _rng.randf_range(pitch - pitch_range, pitch + pitch_range)
			i.play()
			break
