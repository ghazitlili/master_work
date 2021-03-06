# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.cache/wt [current_project]
set_property parent.project_path /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
read_ip /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.xci
set_property is_locked true [get_files /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.xci]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top BUFFER_ROW -part xc7z020clg484-1 -mode out_of_context
rename_ref -prefix_all BUFFER_ROW_
write_checkpoint -noxdef BUFFER_ROW.dcp
catch { report_utilization -file BUFFER_ROW_utilization_synth.rpt -pb BUFFER_ROW_utilization_synth.pb }
if { [catch {
  file copy -force /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.runs/BUFFER_ROW_synth_1/BUFFER_ROW.dcp /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.dcp
} _RESULT ] } { 
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}
if { [catch {
  write_verilog -force -mode synth_stub /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode synth_stub /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_verilog -force -mode funcsim /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode funcsim /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if {[file isdir /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.ip_user_files/ip/BUFFER_ROW]} {
  catch { 
    file copy -force /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_stub.v /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.ip_user_files/ip/BUFFER_ROW
  }
}

if {[file isdir /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.ip_user_files/ip/BUFFER_ROW]} {
  catch { 
    file copy -force /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_stub.vhdl /home/ghazi/Downloads/master_work/BRAM_PRJ_/BRAM_PRJ.ip_user_files/ip/BUFFER_ROW
  }
}
