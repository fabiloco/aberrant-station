extends Node

signal notice_added(notice)

var notices = []

func add_notice(notice):
	notices.append(notice)
	notice_added.emit(notice)
