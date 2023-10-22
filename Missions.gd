extends Node

var curr_round = 2
var max_rounds = 5
var missions_status = {
	1: {
		1: false,
		2: false,
		3: false,
		4: false
	},
	2: {
		1: false,
		2: false,
		3: false,
		4: false
	},
	3: {
		1: false,
		2: false,
		3: false,
		4: false,
		5: false
	},
	4: {
		1: false,
		2: false,
		3: false,
		4: false,
		5: false,
		6: false,
		7: false,
		8: false,
		9: false,
		10: false
	}
}

func all_round_missions_done() -> bool:
	for key in missions_status[curr_round]:
		if missions_status[curr_round][key] == false:
			return false
	return true
