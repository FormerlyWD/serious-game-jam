extends Node2D

func create_outro_message():
	
	$RichTextLabel.text = "Your shift has ended. \n " 
	$RichTextLabel.text += "total points gotten; " 
	$RichTextLabel.text += str(GlobalShiftManager.attained_points)
	$RichTextLabel.text += "/"
	$RichTextLabel.text += str(GlobalShiftManager.all_attainable_points) + "\n"
	
	$RichTextLabel.text += "Thanks for playing!"
	
