# Microsemi Tcl Script
# libero
# Date: Wed Jan 22 08:56:08 2025
# Directory D:\01_hardware\A3P1000\_script_support
# File D:\01_hardware\A3P1000\_script_support\exported.tcl


new_project -location {../ChaineTempsCourt} -name {ChaineTempsCourt} -project_description {} -block_mode 0 -standalone_peripheral_initialization 0 -instantiate_in_smartdesign 1 -use_enhanced_constraint_flow 0 -hdl {VHDL} -family {ProASIC3} -die {A3P1000} -package {144 FBGA} -speed {-1} -die_voltage {} -part_range {} -adv_options {} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/debouncer.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/heartbeat.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/resync.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/rs485.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/sync.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -hdl_source {./src/hdl/top.vhd} 
import_files \
         -convert_EDN_to_HDL 0 \
         -sdc {./src/constraints/timeConstraint.sdc} 
import_files \
         -convert_EDN_to_HDL 0 \
         -pdc {./src/constraints/A3P1000-FG144.pdc} 
set_root -module {top::work} 
save_project 
organize_tool_files -tool {SYNTHESIZE} -file {../ChaineTempsCourt/constraint/timeConstraint.sdc} -module {top::work} -input_type {constraint} 
organize_tool_files -tool {COMPILE} -file {../ChaineTempsCourt/constraint/A3P1000-FG144.pdc} -module {top::work} -input_type {constraint} 
organize_tool_files -tool {COMPILE} -file {../ChaineTempsCourt/constraint/A3P1000-FG144.pdc} -file {../ChaineTempsCourt/constraint/timeConstraint.sdc} -module {top::work} -input_type {constraint} 
