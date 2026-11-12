local colors = require("config.colors")

for _, class in ipairs({
    "^(org.pulseaudio.pavucontrol)(.*)$",
    "^(blueman-manager)$",
    "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)(.*)$",
    "^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)(.*)$",
    "^(CachyOSHello)$",
    "^(zenity)$",
}) do
    hl.window_rule({ match = { class = class }, float = true })
end

for _, title in ipairs({ "Picture in picture", "Save File", "Open File", "Steam - Self Updater" }) do
    hl.window_rule({ match = { class = "^$", title = "^(" .. title .. ")$" }, float = true })
end

hl.window_rule({ match = { class = "^(LibreWolf)$", title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(thunar|nemo)$" }, opacity = "0.92" })
hl.window_rule({ match = { class = "^(discord|armcord|webcord)$" }, opacity = "0.96" })
hl.window_rule({ match = { title = "^(QQ|Telegram)$" }, opacity = "0.95" })
hl.window_rule({ match = { title = "^(NetEase Cloud Music Gtk4)$" }, opacity = "0.95" })

for _, title in ipairs({ "^(Picture-in-Picture)$", "^(imv|mpv|danmufloat|termfloat|nemo|ncmpcpp)$" }) do
    hl.window_rule({
        match = { title = title },
        float = true,
        size = { 960, 540 },
        -- The old `move 25%-` rule was incomplete; center these utility windows.
        center = true,
    })
end

hl.window_rule({ match = { title = "^(danmufloat)$" }, pin = true })
hl.window_rule({ match = { title = "^(danmufloat|termfloat)$" }, rounding = 5 })
hl.window_rule({ match = { class = "^(kitty|Alacritty)$" }, animation = "slide right" })
hl.window_rule({ match = { class = "^(org.mozilla.firefox)$" }, no_blur = true })

hl.window_rule({
    match = { float = true, workspace = "w[fv1-10]" },
    border_size = 2,
    border_color = colors.cachylblue,
    rounding = 8,
})
hl.window_rule({ match = { float = false, workspace = "f[1-10]" }, border_size = 3, rounding = 4 })

hl.workspace_rule({ workspace = "w[tv1-10]", gaps_out = 5, gaps_in = 3 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 5, gaps_in = 3 })

hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "slide top" })
hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide down" })
hl.layer_rule({ match = { namespace = "wallpaper" }, animation = "fade 50%" })
