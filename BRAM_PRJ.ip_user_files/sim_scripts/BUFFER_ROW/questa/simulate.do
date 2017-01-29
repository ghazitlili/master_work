onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib BUFFER_ROW_opt

do {wave.do}

view wave
view structure
view signals

do {BUFFER_ROW.udo}

run -all

quit -force
