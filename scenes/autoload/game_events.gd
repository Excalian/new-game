extends Node

signal experience_vial_collected(number: int)


func emit_experience_vial_collected(number: int):
	experience_vial_collected.emit(number)
