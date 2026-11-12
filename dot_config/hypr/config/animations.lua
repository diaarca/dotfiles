hl.config({ animations = { enabled = true } })

hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1 } } })
hl.curve("smallBounce", { type = "bezier", points = { { 0.33, 1.0 }, { 0.68, 1.06 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })

for _, leaf in ipairs({ "windows", "windowsMove", "windowsOut", "layers" }) do
    hl.animation({ leaf = leaf, enabled = true, speed = 4, bezier = "smallBounce" })
end

for _, leaf in ipairs({ "workspacesIn", "workspacesOut", "specialWorkspace" }) do
    hl.animation({ leaf = leaf, enabled = true, speed = 4, bezier = "smallBounce", style = "slide" })
end
