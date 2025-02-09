#####################################################
# Build Project for Libero
#####################################################
#####################################################

# Close current project if needed
# catch {close_project}

# Set parameters as variables
source ./parameters.tcl;

#Setup Variables
set libero_cmd "new_project \
    	       -location {./$prj_name} \
	       -name {$prj_name} \
	       -family {$prj_family} \
	       -die {$prj_die} \
	       -package {$prj_package} \
	       -speed {$prj_speed} \
	       -hdl {$prj_hdl}";

##Remove any existing project with the Setup name
# eval file delete -force ./$prj_name;
#
##Create New Project
if {[file exists $prj_name]} then {
    #print_message "Info: Error: A project already exists"
    puts stderr "Info: Error: A project already exists";
    puts stderr "Info: Error: Remove '$prj_name' folder";
    exit 1;
} else {
    puts stdout "Project creation...";
    eval $libero_cmd;





#eval $libero_cmd;
#
## Import HDL files
set flist [glob ./_script_support/$hdl_path/*.vhd]
foreach f $flist {
    import_files -hdl_source $f;
}

## Import SDC files
import_files -sdc ./_script_support/$constraints_path/$file_sdc;

## Import SDC files
import_files -pdc ./_script_support/$constraints_path/$file_pdc;

## Select top
# build_design_hierarchy;
set_root top;

## Associate constraint files with Synthesize and Compile Tool
organize_tool_files -tool {SYNTHESIZE} -file ./$prj_name/constraint/$file_sdc \
    -module {top::work} -input_type {constraint};
organize_tool_files -tool {COMPILE} -file ./$prj_name/constraint/$file_pdc \
    -module {top::work} -input_type {constraint};
organize_tool_files -tool {COMPILE} -file ./$prj_name/constraint/$file_pdc \
    -file ./$prj_name/constraint/$file_sdc -module {top::work} -input_type {constraint};


## Associate the constraint file with Verify Timing
organize_tool_files -tool {VERIFYTIMING} \
    -file "./$prj_name/constraint/$file_sdc" \
    -input_type {constraint};

## Save project
save_project;

}
