extends Node

var continueSound = preload("res://assets/audio/soundEffects/buttondefault4.mp3")
var returnSound = preload("res://assets/audio/soundEffects/returnbutton.wav")

var soundDictionary = [continueSound, returnSound]

#Sound Controller Derived from : https://youtu.be/mnm7uV4MOTk?si=Edpxw_AZpkCln1s_

#[continueSound]
func play_preset(soundKey: int, volume: int):
	var instance = AudioStreamPlayer.new()
	instance.stream = soundDictionary[soundKey]
	instance.volume_db = volume
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()


func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
