# ============================================================
# Gapminder Data Analysis & Animation
# ============================================================

# --- Package Management ---
# Define required packages
required_packages <- c(
    "gapminder",
    "ggplot2",
    "dplyr",
    "gganimate",
    "ggridges",
    "gifski",
    "png"
)

# Function to check and install packages
install_if_missing <- function(packages) {
    new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
    if (length(new_packages)) {
        message("Installing missing packages: ", paste(new_packages, collapse = ", "))
        install.packages(new_packages, repos = "http://cran.us.r-project.org")
    }
}

install_if_missing(required_packages)

# Load libraries
library(gapminder)
library(ggplot2)
library(dplyr)
library(gganimate)
library(ggridges)
library(gifski)

# --- Plotting Functions ---

get_rosling_plot <- function(data = NULL) {
    if (is.null(data)) data <- gapminder

    ggplot(data, aes(x = gdpPercap, y = lifeExp, size = pop, color = continent)) +
        geom_point(alpha = 0.6) +
        geom_point(data = filter(data, country == "Poland"), color = "black", shape = 21, stroke = 2) +
        geom_text(data = filter(data, country == "Poland"), aes(label = country), vjust = -1, color = "black", size = 5, show.legend = FALSE) +
        scale_size(range = c(2, 12), breaks = c(1000000, 10000000, 100000000, 500000000), labels = scales::comma) +
        scale_x_log10() +
        labs(
            title = "Year: {frame_time}",
            x = "GDP per Capita (log scale)",
            y = "Life Expectancy",
            size = "Population",
            color = "Continent"
        ) +
        guides(size = guide_legend(override.aes = list(shape = 19, color = "gray50", stroke = 0))) +
        theme_minimal() +
        theme(
            legend.position = "right",
            plot.title = element_text(hjust = 0.5, size = 20),
            axis.title.x = element_text(hjust = 0.5),
            axis.title.y = element_text(hjust = 0.5)
        ) +
        transition_time(year) +
        ease_aes("linear")
}

get_ridgeline_plot <- function(data = NULL) {
    if (is.null(data)) data <- gapminder

    # Fundamental Fix for Oceania visibility (N >= 3)
    data_augmented <- data %>%
        bind_rows(filter(data, continent == "Oceania")) %>%
        bind_rows(filter(data, continent == "Oceania"))

    ggplot() +
        geom_density_ridges(
            data = data_augmented,
            aes(x = lifeExp, y = continent, fill = continent, weight = pop),
            alpha = 0.7,
            scale = 0.95,
            bandwidth = 4,
            jittered_points = FALSE
        ) +
        labs(
            title = "Life Expectancy Distribution by Continent: {frame_time}",
            subtitle = "Height of the ridges represents density",
            x = "Life Expectancy (Years)",
            y = "Continent"
        ) +
        theme_ridges(center_axis_labels = TRUE) +
        theme(
            legend.position = "none",
            plot.title = element_text(hjust = 0.5, size = 16),
            plot.subtitle = element_text(hjust = 0.5),
            axis.title.x = element_text(hjust = 0.5),
            axis.title.y = element_text(hjust = 0.5)
        ) +
        transition_time(year) +
        ease_aes("linear")
}

# ============================================================
# Data Exploration
# ============================================================
data("gapminder")

cat("\n=== Dataset Summary ===\n")
print(summary(gapminder))

cat("\n=== Dataset Structure ===\n")
print(str(gapminder))

# ============================================================
# Visualization 1: The "Rosling" Animated Bubble Chart
# ============================================================

# 1. Standard Render (Square/4:3) and Save
message("Building and rendering Rosling Plot (Standard)...")
p1 <- get_rosling_plot()
anim1 <- animate(p1, renderer = gifski_renderer(), nframes = 100, fps = 10)
anim_save("visualization1.gif", animation = anim1)
message("Saved: visualization1.gif")

# Clean up
rm(anim1, p1)
gc()

# 2. Wide Render (16:9) and Save
message("Building and rendering Rosling Plot (Wide 16:9)...")
p1 <- get_rosling_plot()
anim1_wide <- animate(p1, renderer = gifski_renderer(), width = 800, height = 450, nframes = 100, fps = 10)
anim_save("visualization1_wide.gif", animation = anim1_wide)
message("Saved: visualization1_wide.gif")

# Clean up
rm(anim1_wide, p1)
gc()

# ============================================================
# Visualization 2: The Animated "Ridgeline" Plot
# ============================================================

# 1. Standard Render and Save
message("Building and rendering Ridgeline Plot (Standard)...")
p2 <- get_ridgeline_plot()
anim2 <- animate(p2, renderer = gifski_renderer(), nframes = 100, fps = 10)
anim_save("visualization2.gif", animation = anim2)
message("Saved: visualization2.gif")

# Clean up
rm(anim2, p2)
gc()

# 2. Wide Render (16:9) and Save
message("Building and rendering Ridgeline Plot (Wide 16:9)...")
p2 <- get_ridgeline_plot()
anim2_wide <- animate(p2, renderer = gifski_renderer(), width = 800, height = 450, nframes = 100, fps = 10)
anim_save("visualization2_wide.gif", animation = anim2_wide)
message("Saved: visualization2_wide.gif")

# Clean up
rm(anim2_wide, p2)
gc()

# ============================================================
# Done
# ============================================================
message("\n=== All visualizations generated successfully! ===")
message("Generated files:")
message("  - visualization1.gif (standard)")
message("  - visualization1_wide.gif (16:9)")
message("  - visualization2.gif (standard)")
message("  - visualization2_wide.gif (16:9)")
