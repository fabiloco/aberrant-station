extends Node

var objectives_to_repair = 12
var repaired_objectives = 0

func repaired():
	repaired_objectives += 1
	var remaining = "%0d/%0d" % [repaired_objectives, objectives_to_repair]
	NoticeManager.add_notice({"title": "Object repaired. %s remaining." % remaining})
	if repaired_objectives >= objectives_to_repair:
		NoticeManager.add_notice({"title": "All objects were repaired"})
