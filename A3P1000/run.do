# Specify project info
variable tbEnt code_lock_tb
variable projLibs {
  work
}

# This procedure is a hack to get the path to this script
# "info script" doesn't work for ModelSim do-files
proc getScriptDir {} {

  # Get the last command from the history
  set histLines [split [history] "\n"]
  set lastLineIndex [expr [llength $histLines] - 1 ]
  set lastLine [lindex $histLines $lastLineIndex]

  # Remove all quotes
  set trimmed [regsub -all {(\")} $lastLine {}]

  # Remove the first two words
  set trimmed [regsub -all {(^\s*\w+\s+\w+\s+)} $trimmed {}]

  # Remove the script name from the end of the string
  set trimmed [regsub -all {(run.do$)} $trimmed {}]

  # Trim whitespace
  set trimmed [string trim $trimmed]

  # Remove backslashes (ModelSim uses forward slash on all platforms)
  set trimmed [regsub -all {(\\)} $trimmed {}]

  # If the string is empty
  if {$trimmed eq ""} {
    return "./"
  }

  # The trimmed string should contain the location of this script
  return $trimmed
}

# Stop any ongoing simulation
if {[runStatus] != "nodesign"} {
  quit -sim
}

# cd to the dir of this file
cd [getScriptDir]

# Create the libraries if the folders don't exist
foreach lib $projLibs {
  if {![file isdirectory $lib]} {
    vlib $lib
  }
}

project open project.mpf
project compileall

proc runtb {} {
  echo "Type 'source code_lock/code_lock_tb.tcl'"
  echo "in the ModelSim console to run the testbench"
}

echo "***********************************************************************"
echo "*                                                                     *"
echo "* Thank you for downloading this example from VHDLwhiz.com            *"
echo "*                                                                     *"
echo "* The associated blog post for this example project:                  *"
echo "* https://vhdlwhiz.com/tcl-driven-testbench-for-vhdl-code-lock-module *"
echo "*                                                                     *"
echo "* To run the testbench, source the Tcl file in the ModelSim console:  *"
echo "* ModelSim> source code_lock/code_lock_tb.tcl                         *"
echo "*                                                                     *"
echo "***********************************************************************"