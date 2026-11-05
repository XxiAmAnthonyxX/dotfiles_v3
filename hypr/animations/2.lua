-- Bezier
hl.curve("my_bezier", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })

-- Global
hl.animation({ leaf = "global", enabled = true, speed = 2.0, bezier = "my_bezier" })

-- Windows
hl.animation({ leaf = "windows", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })

-- Layers
hl.animation({ leaf = "layers", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.0, bezier = "my_bezier", style = "popin" })

-- Fade
hl.animation({ leaf = "fade", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeGlow", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeLayers", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadePopups", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "fadeDpms", enabled = true, speed = 2.0, bezier = "my_bezier" })

-- Border / Angle
hl.animation({ leaf = "border", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 2.0, bezier = "my_bezier", style = "once" })
hl.animation({ leaf = "shadowangle", enabled = true, speed = 2.0, bezier = "my_bezier", style = "once" })
hl.animation({ leaf = "glowangle", enabled = true, speed = 2.0, bezier = "my_bezier", style = "once" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2.0, bezier = "my_bezier", style = "slidevert" })

-- Misc
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 2.0, bezier = "my_bezier" })
hl.animation({ leaf = "monitorAdded", enabled = true, speed = 2.0, bezier = "my_bezier" })
