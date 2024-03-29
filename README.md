# Lab-tester
## Description
A tool for developers to automatically test Labs.  Labs present a variety of applications of J and its addons, so this tool checks the compatibility of Labs with the installed version of J.
## How to use it?
Testing script was written in AppleScript. The interpreter (```osascript``` command in the terminal) and editor (Script Editor) is available by default on macOS. After downloading the files from the repository, call the following command in the terminal in the directory where the downloaded script is located:

```osascript lab-tester.applescript```

Do not click the mouse or press the keyboard keys while the script is running.

Before the first test, you should additionally call the following command to test the lab ```Shared Library (c) (dll/so/dylib) - writing a DLL```. You only need to do it once after installing J.

```make -f /your_path_to_J/addons/labs/labs/examples/dllwrite/makefile_macos```

The script is expected to run for 20 minutes. The result of the script is a report file with a name starting with ```report``` followed by current date. The format of the report file is as follows:
```
=========================================================
A J Introduction                                  <-- Correct!
=========================================================
Best Fit                   <-- Reference output missing (TODO)
diff: ./reference/BestFit.txt: No such file or directory
=========================================================
Sequential Machines
96c96                       <-- Difference between output file
< 0.008715 2.71298e7                 and reference file can be
---                                      caused by an error or
> 0.008396 2.71298e7             nondeterministic calculations
=========================================================
```
In addition, as a result of the script, a ```output``` directory will be created, in which the lab outputs will be placed. They are compared (```diff```) with the corresponding files in the ```reference``` directory when the report is created.

## Why aren't all the labs tested?
The following labs are not tested.

| Lab                                               | Reason                                     |
|---------------------------------------------------|--------------------------------------------|
| Circuit Theory I                                  | Dialog window with error at the beginning. |
| Circuit Theory II                                 | Dialog window with error at the beginning. |
| Client/Server (Simple Socket)                     | Requires two JQt instances.                |
| Client/Server - parallel each - parallel jobs     | Is obsolete.                               |
| Compositions @ @: & &:                            | Requires user interaction (dialog window)  |
| J As Your First Computer Language                 | Requires user interaction (dialog window)  |
| J By Point & Click I                              | Freezes JQt at the beginning.              |
| Math Tables                                       | Requires user interaction.                 |
| Performance Monitor Utilities                     | Requires user interaction.                 |
| Socket Driver Server                              | Requires two JQt instances.                |
| Socket Driver Server - Client                     | Requires two JQt instances.                |
| Shared Library (d) (windows only) - callback      | Not for macOS.                             |
| Shared Library (e) (windows only) - file examples | Not for macOS.                             |

## How to add a new lab to a testing script?
Assuming that lab is already in JQt. Generate an output file similar to the files in the ```reference``` directory. Then send this file to email
[marcin.zolek@students.mimuw.edu.pl](mailto:marcin.zolek@students.mimuw.edu.pl)
