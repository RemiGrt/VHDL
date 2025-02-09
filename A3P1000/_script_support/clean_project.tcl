#####################################################
# Remove _old folders
#####################################################
#####################################################

proc removeFiles {pathToFolder} {
    set testCatch [catch {set flistOld [glob $pathToFolder*]} resultCatch]

    if {$testCatch} {
	puts "No files to delete"
    } else {
	foreach f $flistOld {
	    puts "Delete some files $f"
	    file delete $f
	}
    }   
}

proc removeFile {pathToFile} {
    if {[file exists $pathToFile]} then {
	file delete $pathToFile
    }  else {
	puts "No file to delete"
    }   
}

set pathToClean ./src/constraints/_old/
removeFiles $pathToClean

set pathToClean ./src/hdl/_old/
removeFiles $pathToClean

removeFile ./src/sim/vsim.wlf

file delete -force -- ./src/sim/work

