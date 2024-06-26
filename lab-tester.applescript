(* Author: Marcin Żołek <marcin.zolek@students.mimuw.edu.pl> *)

-- labs that have to be tested manually, so they are not tested by this script
set manualLabs to {"Circuit Theory I", "Circuit Theory II"} & ¬
	{"Client/Server (Simple Socket)", "Client/Server - parallel each - parallel jobs"} & ¬
	{"Compositions @ @: & &:"} & ¬
	{"J As Your First Computer Language"} & ¬
	{"J By Point & Click I"} & ¬
	{"Math Tables"} & ¬
	{"Performance Monitor Utilities"} & ¬
	{"Socket Driver Server", "Socket Driver Server - Client"} & ¬
	{"Shared Library (d) (windows only) - callback", "Shared Library (e) (windows only) - file examples"}
-- labs that require manual restoration of focus (for example, labs that open a browser or pdf file, so not just J windows)
set focusLabs to {"Imagekit Addon", "Imagekit Addon (jandroid)", "Imagekit Html", "JOD (1) Introduction", "JOD (3) Best Practices"}
set separator to "================================================================================
"
-- report file contains the current date
set reportFile to "report-" & (do shell script "date '+%Y-%m-%d-%H-%M-%S'") & ".txt"
do shell script "rm -rf output"
do shell script "mkdir -p output"
do shell script "date > ./" & reportFile

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
				if manualLabs does not contain labName then
					-- simplify name of the lab (simplified lab name is used as output/reference file name)
					set labSimplifiedName to do shell script "echo " & quoted form of labName & " | sed 's/[^0-9a-zA-Z]*//g'"
					-- run the lab
					click button "Run" of group 2 of window "Lab select"
					delay 1
					-- get number of sections
					set content to value of text area 1 of window "Term"
					if (do shell script "echo " & quoted form of content & " | grep -c 'Chapter' || true") > 0 then
						set labSections to 256 -- impossible to get number of sections because lab has chapters
					else
						set labSections to do shell script "echo " & quoted form of content & " | grep -o \"1 of [1-9][0-9]*\" | head -n 1 | sed \"s/1 of \\([1-9][0-9]*\\)/\\1/\""
					end if
					-- check if restore focus
					set restoreFocus to focusLabs contains labName
					-- run through the lab
					repeat labSections times
						keystroke "j" using command down
						delay 0.1
						if restoreFocus then -- focus is not restored by default
							-- focus Term window
							set frontmost to true
							perform action "AXRaise" of window "Term"
							delay 0.1
						end if
						-- check if end of lab (useful when number of sections is not known)
						set content to value of text area 1 of window "Term"
						if (text (paragraph 1) thru -1 of content) contains "nd of lab" then
							exit repeat
						end if
					end repeat
					-- save content
					do shell script "echo " & quoted form of content & " > ./output/" & labSimplifiedName & ".txt"
					-- generate report
					do shell script "echo " & quoted form of separator & quoted form of labName & " >> ./" & reportFile
					do shell script "diff ./output/" & labSimplifiedName & ".txt" & " " & "./reference/" & labSimplifiedName & ".txt >> " & reportFile & " 2>&1 || true"
				end if
			end tell
		end tell
		try
			quit
		on error number -128
			do shell script "echo 'Quitting JQt returned error -128 in script' >> ./" & reportFile
		end try
		delay 1
		-- check if quit was successful
		if application "jqt9.5" is running then
			do shell script "echo 'Quitting JQt failed ' >> ./" & reportFile
			tell application "System Events"
				tell process "j"
					click button 1 of window "Term"
				end tell
			end tell
			delay 1
		end if
	end tell
end repeat

-- final separator
do shell script "echo " & quoted form of separator & " >> ./" & reportFile
