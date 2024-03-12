extends Node


func on_press(body):
	if RepairObjectives.complete:
		WinScreen.show_screen()
	else:
		NoticeManager.add_notice({"title": "Repair all the objects to return."})
		var remaining = "%0d/%0d" % [RepairObjectives.repaired_objectives, RepairObjectives.objectives_to_repair]
		NoticeManager.add_notice({"title": "Object repaired. %s remaining." % remaining})
