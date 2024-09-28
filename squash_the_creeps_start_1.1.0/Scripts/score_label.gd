extends Label

var score = 0
var score_increase = 0.5

func on_jump():
	score_increase = 0.5
	print("Reset score_increase:", score_increase)

func _on_mob_squashed():
	score_increase *= 2
	print("score_increase:", score_increase)
	score+=score_increase
	print("Score:", score)
	text = "Score: %s" % score
