source grade.tcl
create_wave_config; add_wave [get_objects -r]; set_property needs_save false [current_wave_config]
run 1000000ns

if {$GRADE == 1} {
    exit
}
