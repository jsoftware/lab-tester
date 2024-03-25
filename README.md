# Lab-tester
## Description
Tool for automatic testing Labs available in JQt (Help > Studio > Labs...) on macOS. Written in AppleScript. The script allows testing labs that do not require non-standard user interaction.

## Run
Command in terminal

```osascript lab-tester.applescript```

creates
* report.txt file containing information on lab fragments that differ from the labs' reference outputs in ```reference``` directory,
* ```output``` directory containing outputs of the labs.

The expected running time of the script is about 30 minutes.
