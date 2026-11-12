local defaults = require("config.defaults")
local mod = defaults.main_mod

local function bind(keys, action, description)
    hl.bind(keys, action, { description = description })
end

bind(mod .. " + RETURN", hl.dsp.exec_cmd(defaults.terminal), "Open terminal")
if defaults.file_manager ~= "" then
    bind(mod .. " + E", hl.dsp.exec_cmd(defaults.file_manager), "Open file manager")
end
bind(mod .. " + Q", hl.dsp.window.close(), "Close window")
bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd([[loginctl terminate-user ""]]), "End user sessions")
bind(mod .. " + V", hl.dsp.window.float(), "Toggle floating")
bind(mod .. " + SPACE", hl.dsp.exec_cmd(defaults.app_launcher), "Open application launcher")
bind(mod .. " + F", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind(mod .. " + Y", hl.dsp.window.pin(), "Pin window")
bind(mod .. " + J", hl.dsp.layout("togglesplit"), "Toggle split")

bind("Print", hl.dsp.exec_cmd(defaults.shot_region), "Screenshot region")
bind("CTRL + Print", hl.dsp.exec_cmd(defaults.shot_window), "Screenshot window")
bind("ALT + Print", hl.dsp.exec_cmd(defaults.shot_screen), "Screenshot display")
bind(mod .. " + K", hl.dsp.group.toggle(), "Toggle window group")
bind(mod .. " + Tab", hl.dsp.group.next(), "Next window in group")

bind(mod .. " + SHIFT + G", function()
    hl.config({ general = { gaps_out = 5, gaps_in = 3 } })
end, "Restore gaps")
bind(mod .. " + G", function()
    hl.config({ general = { gaps_out = 0, gaps_in = 0 } })
end, "Remove gaps")

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd([=[pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{if($1>100) system("pactl set-sink-volume @DEFAULT_SINK@ 100%")}' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > "/tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"]=]), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd([=[pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | awk '{print $1}' | head -1 > "/tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"]=]), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd([=[amixer sset Master toggle | sed -En '/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p' | head -1 > "/tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob"]=]), { repeating = true, locked = true })

bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Play/pause")
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Next track")
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Previous track")
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true, locked = true })
bind(mod .. " + L", hl.dsp.exec_cmd("swaylock-fancy -e -K -p 10 -f Hack-Regular"), "Lock screen")
bind(mod .. " + O", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), "Reload Waybar")

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    bind(mod .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }), "Move window " .. direction)
    bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }), "Focus " .. direction)
end

bind(mod .. " + R", hl.dsp.submap("resize"), "Enter resize mode")
local resize_keys = {
    { "right", 15, 0 }, { "left", -15, 0 }, { "up", 0, -15 }, { "down", 0, 15 },
    { "l", 15, 0 }, { "h", -15, 0 }, { "k", 0, -15 }, { "j", 0, 15 },
}
hl.define_submap("resize", function()
    for _, resize in ipairs(resize_keys) do
        bind(resize[1], hl.dsp.window.resize({ x = resize[2], y = resize[3], relative = true }), "Resize window")
    end
    bind("escape", hl.dsp.submap("reset"), "Leave resize mode")
end)
for _, resize in ipairs(resize_keys) do
    bind(mod .. " + CTRL + SHIFT + " .. resize[1],
        hl.dsp.window.resize({ x = resize[2], y = resize[3], relative = true }), "Resize window")
end
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Drag window" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Physical number-row keys work with AZERTY, including Shift-modified moves.
for workspace = 1, 10 do
    local key = "code:" .. (workspace + 9)
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }), "Workspace " .. workspace)
    bind(mod .. " + CTRL + " .. key,
        hl.dsp.window.move({ workspace = workspace, follow = true }), "Move to workspace " .. workspace)
    bind(mod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = workspace, follow = false }), "Move silently to workspace " .. workspace)
end
bind(mod .. " + CTRL + left", hl.dsp.window.move({ workspace = "-1", follow = true }), "Move to previous workspace")
bind(mod .. " + CTRL + right", hl.dsp.window.move({ workspace = "+1", follow = true }), "Move to next workspace")

bind(mod .. " + period", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + semicolon", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + comma", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(mod .. " + slash", hl.dsp.focus({ workspace = "previous" }), "Last workspace")
bind(mod .. " + equal", hl.dsp.window.move({ workspace = "special:special" }), "Move to special workspace")
bind(mod .. " + asterisk", hl.dsp.workspace.toggle_special("special"), "Toggle special workspace")
bind(mod .. " + F1", hl.dsp.workspace.toggle_special("scratchpad"), "Toggle scratchpad")
bind(mod .. " + ALT + SHIFT + F1",
    hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }), "Move silently to scratchpad")

hl.config({
    binds = {
        allow_workspace_cycles = true,
        workspace_back_and_forth = 1,
        workspace_center_on = 1,
        movefocus_cycles_fullscreen = true,
        window_direction_monitor_fallback = true,
    },
})
