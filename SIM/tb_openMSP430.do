vlib work
vmap work work

vlog -work work tb_openMSP430_fpga.v
vlog -work work openMSP430.v
vlog -work work openMSP430_fpga.v
vlog -work work altera_mf.v
vlog -work work rom16x2048.v
vlog -work work ram16x512.v

vlog -work work dma_decode_16b.v
vcom -work work dma_channel.vhd
vlog -work work dma_pri.v
vcom -work work dma_master.vhd

vlog -work work dma_tfbuffer.v

vcom -work work fifo.vhd
vcom -work work fifo_ctl_in.vhd
vcom -work work fifo_ctl_out.vhd



vcom -work work viterbi_top.vhd
vcom -work work acsunit.vhd
vcom -work work controller_ram.vhd
vcom -work work ram_32_64.vhd
vcom -work work ram_trace_top.vhd
vcom -work work trace.vhd
vcom -work work compare.vhd
vcom -work work trace_controller.vhd
vcom -work work viterbi_butterfly.vhd
vcom -work work viterbi_dis.vhd
vcom -work work viterbi_mmu.vhd

vcom -work work conv_encode7.vhd
vcom -work work viterbi_conv_top.vhd

vlog -work work io_cell.v
#vlog -work work msp_debug.v
vlog -work work omsp_alu.v
vlog -work work omsp_and_gate.v
vlog -work work omsp_clock_gate.v
vlog -work work omsp_clock_module.v
vlog -work work omsp_clock_mux.v
vlog -work work omsp_dbg.v
vlog -work work omsp_dbg_hwbrk.v
vlog -work work omsp_dbg_i2c.v
vlog -work work omsp_dbg_uart.v
vlog -work work omsp_execution_unit.v
vlog -work work omsp_frontend.v
vlog -work work omsp_gpio.v
vlog -work work omsp_mem_backbone.v
vlog -work work omsp_multiplier.v
vlog -work work omsp_register_file.v
vlog -work work omsp_scan_mux.v
vlog -work work omsp_sfr.v
vlog -work work omsp_sync_cell.v
vlog -work work omsp_sync_reset.v
vlog -work work omsp_timerA.v
vlog -work work omsp_timerA_defines.v
vlog -work work omsp_timerA_undefines.v
vlog -work work omsp_wakeup_cell.v
vlog -work work omsp_watchdog.v
vlog -work work openMSP430_defines.v
vlog -work work openMSP430_undefines.v
vlog -work work ram.v
vlog -work work template_periph_8b.v
vlog -work work template_periph_16b.v
vlog -work work timescale.v

vlog -work work uart_rx.v
vlog -work work uart_speed_select.v
vlog -work work uart_top.v
vlog -work work uart_tx.v
vlog -work work print_task.v

vsim -novopt tb_openMSP430_fpga
#add wave sim:/tb_openMSP430/fifo_ctl_1/*
#add wave sim:/tb_openMSP430/u_dma_master/u_dma_decode_16b/*
#add wave sim:/tb_openMSP430/u_dma_master/channel_0/*
#add wave sim:/tb_openMSP430/u_dma_master/channel_1/*
#add wave sim:/tb_openMSP430/u_dma_master/channel_2/*
#add wave sim:/tb_openMSP430/u_dma_master/channel_3/*
#add wave sim:/tb_openMSP430/u_dma_master/channel_4/*
add wave -position insertpoint sim:/tb_openMSP430_fpga/*
add wave -position insertpoint sim:/tb_openMSP430_fpga/msp430/uart_top_u/*
radix -hex
view wave
run -all

