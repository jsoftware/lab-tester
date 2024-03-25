(* Author: Marcin Żołek <marcin.zolek@students.mimuw.edu.pl> *)

set separator to "================================================================================
"
do shell script "mkdir -p output"
do shell script "date +'%m/%d/%Y' > ./report.txt"

tell application "jqt9.5"
	activate
	delay 1
	tell application "System Events"
		tell process "j"
			-- get number of labs
			click menu item "Labs..." of menu 1 of menu item "Studio" of menu 1 of menu bar item "Help" of menu bar 1
			delay 1
			set labsNum to number of items of every row of list 1 of group 2 of window "Lab select"
			-- close Lab select window
			click button 1 of window "Lab select"
			delay 1
		end tell
	end tell
	quit
end tell

-- for each lab...
repeat with labId from 0 to labsNum - 1
	if {13, 14, 15, 16, 17, 18, 22, 47, 76, 77, 88, 89, 90, 91, 92, 93} does not contain labId then -- labs that has to be tested manually
		tell application "jqt9.5"
			activate
			delay 1
			tell application "System Events"
				tell process "j"
					-- open Lab select window
					click menu item "Labs..." of menu 1 of menu item "Studio" of menu 1 of menu bar item "Help" of menu bar 1
					delay 1
					-- select lab
					repeat labId times
						key code 125
					end repeat
					delay 1
					set labName to item 1 of value of attribute "AXTitle" of UI element of row (labId + 1) of list 1 of group 2 of window "Lab Select"
					click button "Run" of group 2 of window "Lab select"
					delay 1
					-- get number of sections
					set content to value of text area 1 of window "Term"
					if (do shell script "echo " & quoted form of content & " | grep -c 'Chapter' || true") > 0 then
						set labSections to 256 -- impossible to get number of sections because lab has chapters
					else
						set labSections to do shell script "echo " & quoted form of content & " | grep -o \"1 of [1-9][0-9]*\" | head -n 1 | sed \"s/1 of \\([1-9][0-9]*\\)/\\1/\""
					end if
					-- run through the lab
					repeat labSections times
						keystroke "j" using command down
						delay 0.1
						-- focus Term window
						set frontmost to true
						perform action "AXRaise" of window "Term"
						delay 0.1
						-- check if end of lab (useful when number of sections is not known)
						set content to value of text area 1 of window "Term"
						if (text (paragraph 1) thru -1 of content) contains "nd of lab" then
							exit repeat
						end if
					end repeat
					-- save content and generate report
					do shell script "echo " & quoted form of content & " > ./output/" & labId & ".txt"
					do shell script "echo " & quoted form of separator & quoted form of labName & " >> ./report.txt"
					do shell script "diff ./output/" & labId & ".txt" & " " & "./reference/" & labId & ".txt >> report.txt || true"
				end tell
			end tell
			try
				quit
			on error number -128
				-- That is OK
			end try
		end tell
	end if
end repeat
