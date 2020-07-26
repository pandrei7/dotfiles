# A function which displays the current time,
# used to customize the "Pure" fish prompt.
function _custom_prompt_time
    set --local time (date +%H:%M)
    set --local time_color (_pure_set_color $pure_color_command_duration)

    echo "$time_color$time"
end
