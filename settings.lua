settings = {}

settings["defaultDuration"] = 5000
settings["position"] = "top-right"
settings["enableTestCommand"] = true

settings["types"] = {
    ["info"] = {
        icon = "fas fa-info-circle",
        title = "Information",
        styling = {
            background = "#202727e6",
            text_color = "#3498db",
            icon_color = "#3498db"
        }
    },
    ["error"] = {
        icon = "fas fa-exclamation-circle",
        title = "Error",
        styling = {
            background = "#202727e6",
            text_color = "#e74c3c",
            icon_color = "#e74c3c"
        }
    },
    ["success"] = {
        icon = "fas fa-check-circle",
        title = "Success",
        styling = {
            background = "#202727e6",
            text_color = "#2ecc71",
            icon_color = "#2ecc71"
        }
    },
    ["warning"] = {
        icon = "fas fa-exclamation-triangle",
        title = "Warning",
        styling = {
            background = "#202727e6",
            text_color = "#f39c12",
            icon_color = "#f39c12"
        }
    }
}
