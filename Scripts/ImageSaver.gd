extends Node

func trySaveImage(image: Image) -> void:
	var imageCopy : Image = image.duplicate()
	imageCopy.resize(500, 500, Image.INTERPOLATE_NEAREST)
	
	var time = str(Time.get_unix_time_from_system()).replace(".", "-")
	
	match OS.get_name():
		"Web":
			var buffer = imageCopy.save_png_to_buffer()
			JavaScriptBridge.download_buffer(buffer, "conway-" + time +".png", "image/png")
		_:
			imageCopy.convert(Image.FORMAT_RGB8)
			var imagePath = "user://conway-" + time + ".png"
			#var imagePath = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES) \
			#+ "/" + "game_of_life_" + time + ".png"
			imageCopy.save_png(imagePath)
		
	
