extends Node

var objectives_to_repair = 14
var repaired_objectives = 0
var complete = false

func repaired():
	repaired_objectives += 1
	var remaining = "%0d/%0d" % [repaired_objectives, objectives_to_repair]
	NoticeManager.add_notice({"title": "Object repaired. %s remaining." % remaining})
	if repaired_objectives >= objectives_to_repair:
		complete = true
		NoticeManager.add_notice({"title": "All objects were repaired. Come back to your spaceship to complete the mission."})
