#####################################################
# Copy Files
# This script first save file in ./src/hdl into _old folder
# then Copy files (.hdl .pdc .sdc) files from Libero
# First step to generate script that build project
#####################################################


# Read project parameters
source ../parameters.tcl;

# Set list of all .vhd files (and check if error in testCatch
set testCatch [catch {set flistOld [glob ./src/hdl/*.vhd]} resultCatch]

# Move previous version of .hdl files in _old folder
if {$testCatch} {
    puts "No HDL files to move in old folder"
} else {
    foreach f $flistOld {
	file rename -force $f "./src/hdl/_old"
    }
}

# Set list of all .vhd files
set flist [glob ../$prj_name/hdl/*.vhd]
#
## Copy hdl files to src folder
foreach f $flist {
    file copy $f "./src/hdl"
}

#
# SDC
#

# set variable testCatch
set testCatch [catch {set file $constraints_path/$file_sdc} resultCatch]

# Move previous version of .sdc file in _old folder
if {$testCatch} {
    puts "No SDC files to move in old folder"
} else {
	file rename -force $constraints_path/$file_sdc "./src/constraints/_old"
}

# Copy SDC file to src folder
file copy ../$prj_name/constraint/$file_sdc "./src/constraints"

#
# PDC
#

# set variable testCatch
set testCatch [catch {set file $constraints_path/$file_pdc} resultCatch]

# Move previous version of .sdc file in _old folder
if {$testCatch} {
    puts "No PDC files to move in old folder"
} else {
    file rename -force $constraints_path/$file_pdc "./src/constraints/_old"
}

# Copy PDC files to src folder
file copy ../$prj_name/constraint/$file_pdc "./src/constraints"
