# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.cache/wt [current_project]
set_property parent.project_path /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
add_files -quiet /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.runs/STORE_DISPARITY_IMAGE_synth_1/STORE_DISPARITY_IMAGE.dcp
set_property used_in_implementation false [get_files /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.runs/STORE_DISPARITY_IMAGE_synth_1/STORE_DISPARITY_IMAGE.dcp]
read_ip /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.xci
set_property used_in_implementation false [get_files -all /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW_ooc.xdc]
set_property used_in_implementation false [get_files -all /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.dcp]
set_property is_locked true [get_files /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW/BUFFER_ROW.xci]

read_verilog -library xil_defaultlib {
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/sate_machine.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/READ_FILE_BRAM.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/MIN.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/MIN_8_bytes.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/STORE_V_DISPARITY.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/DATA_PROCESS.v
  /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/new/TOP.v
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top TOP -part xc7z020clg484-1
write_checkpoint -noxdef TOP.dcp
catch { report_utilization -file TOP_utilization_synth.rpt -pb TOP_utilization_synth.pb }