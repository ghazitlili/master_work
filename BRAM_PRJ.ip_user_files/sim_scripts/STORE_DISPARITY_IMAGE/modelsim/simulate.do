onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.STORE_DISPARITY_IMAGE xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {STORE_DISPARITY_IMAGE.udo}

run -all

quit -force
