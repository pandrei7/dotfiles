#!/usr/bin/env fish

# Added so that the cronjob can change the GNOME session?
set -l PID (pgrep gnome-session)
set -x DBUS_SESSION_BUS_ADDRESS (grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ | cut -d= -f2-)

set -g date_format "%H:%M:%S"
set -g times_file "/home/andrei/.local/etc/sync-my-theme-omg/times.txt"
set -g api_resp_file "/home/andrei/.local/etc/sync-my-theme-omg/api_resp.json"

# Write a message prefixed with a timestamp.
function log -a "message"
    echo (date '+%F %T') "$message"
end

# Make sure we know the correct sunset and sunrise times.
# This is done by querying an API once a day and caching its response.
function synchronize_times
    if not test -e $times_file
        log "Times file does not exist. Creating an empty file."
        # Create it "in the past", to force an update.
        touch -d "48 hours ago" $times_file
    end

    set -l mod_date (date -r $times_file +%D)
    set -l today (date +%D)

    if [ $mod_date != $today ]
        log "Synching sunrise/sunset times..."

        set -l coords (string split ' ' (gsettings get org.gnome.settings-daemon.plugins.color night-light-last-coordinates | tr -d '(),'))
        set -l url "https://api.sunrise-sunset.org/json?lat=$coords[1]&lng=$coords[2]&formatted=0"

        if not curl -s $url > $api_resp_file
            log "Failed to curl '$url'. Retrying later."
            return -1
        end

        # Parse the times into our format.
        date -d (jq .results.sunrise $api_resp_file | tr -d '"') +$date_format > $times_file
        date -d (jq .results.sunset $api_resp_file | tr -d '"') +$date_format >> $times_file
        log "Updated times to $(cat $times_file | tr '\n' ' ')"
    end
end

# Only allow the theme to be synched when night light is enabled.
function should_run
    set -l option (gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled)
    return ($option = 'true')
end

# Return the name of the theme we should use right now.
function choose_theme
    # Used initially, but GNOME is bad. These timestamps work differently.
    # set -l sunrise (gsettings get org.gnome.settings-daemon.plugins.color night-light-schedule-to)
    # set -l sunset (gsettings get org.gnome.settings-daemon.plugins.color night-light-schedule-from)

    set -l sunrise (date -d (head -1 $times_file) +%s)
    set -l sunset  (date -d (tail -1 $times_file) +%s)
    set -l now (date +%s)

    # "Go dark" half an hour earlier than the sunset (1800s = 30m).
    if test $sunrise -le $now; and test $now -le (math $sunset - 1800)
        echo "prefer-light"
    else
        echo "prefer-dark"
    end
end

# Change the theme to the given one, if necessary.
function apply_theme -a "wanted_theme"
    set -l curr_theme (gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

    if [ "$curr_theme" != "$wanted_theme" ]
        log "Appyling theme '$wanted_theme'."
        gsettings set org.gnome.desktop.interface color-scheme $wanted_theme
    end
end

# Do everything...
function main
    if not should_run
        # This is a bit arbitrary now.
        log "Night light is disabled. Refusing to sync the theme."
        return 0
    end

    if not synchronize_times
        log "Failed to synchronize times. Quitting."
    end

    set -l theme (choose_theme)
    apply_theme $theme
end

main
