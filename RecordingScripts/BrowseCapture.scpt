global targetDomain
global folderName

-- options
set targetDomain to "domaintoRecord.com"
set folderName to (path to desktop as text) & "folderNameDesired"

-- main code
global recordingFile
global newMovieRecording
on startRecording(filePath)
	set recordingFile to a reference to file filePath
	tell application "QuickTime Player"
		set newMovieRecording to new movie recording
		tell newMovieRecording
			start
		end tell
	end tell
end startRecording

on stopRecording()
	tell application "QuickTime Player"
		tell newMovieRecording
			pause
			save newMovieRecording in recordingFile
			stop
			close newMovieRecording
		end tell
	end tell
end stopRecording

on checkSite()
	tell application "application name"
		repeat with win in windows
			set curUrl to URL of active tab of win
			if curUrl contains targetDomain then
				return true
			end if
		end repeat
		return false
	end tell
end checkSite

on getTimestamp(now)
	set stamp to {¬
		year of now, "-", ¬
		month of now, "-", ¬
		day of now, " ", ¬
		hours of now, " ", ¬
		minutes of now, " ", ¬
		seconds of now}
	return stamp as string
end getTimestamp

global moviePath
global recordingStatus
global startTime
set recordingStatus to false
on update()
	set siteStatus to checkSite()
	log siteStatus
	if siteStatus then
		if not recordingStatus then
			set recordingStatus to true
			set startTime to current date
			set moviePath to folderName & ":" & getTimestamp(startTime)
			log moviePath
			startRecording(moviePath & ".mov")
		end if
	else if recordingStatus then
		set recordingStatus to false
		stopRecording()
		set duration to (current date) - startTime
		set beforeName to moviePath & ".mov"
		set afterName to getTimestamp(startTime) & " +" & duration & ".mov"
		tell application "Finder"
			set the name of file beforeName to afterName
		end tell
	end if
end update

-- infinite loop
repeat
	update()
	delay 1
end repeat
