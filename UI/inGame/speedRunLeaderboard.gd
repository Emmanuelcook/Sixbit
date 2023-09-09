extends Node2D

#Score System
var scoreSavedAtStart = []
var isPlayerInLeaderboard = false
var playerScoreInLeaderboard = 0
var playerScoreInLeaderboardKey = 0
var newTimeToLB = false
var personalPB = false
var highScore = false
var highScoreRank = 99
var betterScoreThanLB = false 
var timeToFinishForSilentWolf = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	$SRSubmit/score.text = Global.saveForLeaderBoardDisplay
	Global.saveForLeaderBoardDisplay = ""
#	timeToFinishForSilentWolf = 100000 - Global.SRtime_ToFinish
	yield(SilentWolf.Scores.get_high_scores(0, "speedrun2"), "sw_scores_received")

	var i = 0
	
	for score in SilentWolf.Scores.scores:
		scoreSavedAtStart.push_back({"name" : score.player_name, "score" : score.score})
		if score.player_name == Global.playerName:
			isPlayerInLeaderboard = true
			playerScoreInLeaderboard = score.score
			playerScoreInLeaderboardKey = i
		i += 1
	
	i = 0
		
	#enfin on ecrit tous les scores au bon endroit
	var j = 0

	for score in scoreSavedAtStart:
		j += 1
		if j < 6:
			
			$Name.get_node(str(j)).bbcode_text = str(score.name)
				
			var invTimeBack = (100000 - score.score)

			var LeaderboardSecs = fmod(invTimeBack, 60)
			var LeaderboardMils = fmod(invTimeBack,1)*100
			var LeaderboardMins = fmod(invTimeBack, 60*60) / 60

			var LeaderboardTime = "%02d:%02d:%02d" % [LeaderboardMins, LeaderboardSecs,LeaderboardMils]

			$Time.get_node(str(j)).bbcode_text = str(LeaderboardTime)

func _on_Main_pressed():
	Global.resetSR()
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")


func _on_SeeSRLB_pressed():
	Global.resetSR()	
	Global.speedRunActive = true
	Global.speedRunFinished = false
	get_tree().change_scene("res://Levels/Desert/Level1.tscn")
