extends Node

var curr_round = 1
var missions_status = {
	1: {
		1: false,
		2: false
	},
	2: {
		1: false,
		2: false,
		3: false
	}
}

func all_round_missions_done() -> bool:
	for key in missions_status[curr_round]:
		if missions_status[curr_round][key] == false:
			return false
	return true
