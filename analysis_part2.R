# ============================================================
# Gapminder Analysis Part 2
# ============================================================

# --- Libraries ---
library(gapminder)
library(ggplot2)
library(dplyr)
library(gganimate)
library(gifski)

# ============================================================
# Visualization 3: The Bar Chart Race (GDP per Capita)
# ============================================================

# 1. Data Transformation with Interpolation
gapminder_interp <- gapminder %>%
    group_by(country, continent) %>%
    do({
        d <- .
        # Interpolating every 0.2 years for smooth movement
        years_expanded <- seq(min(d$year), max(d$year), by = 0.2)
        gdp_approx <- approx(d$year, d$gdpPercap, xout = years_expanded)$y
        data.frame(year = years_expanded, gdpPercap = gdp_approx)
    }) %>%
    ungroup()

# 2. Ranking the Interpolated Data
gapminder_ranked <- gapminder_interp %>%
    group_by(year) %>%
    arrange(desc(gdpPercap)) %>%
    mutate(
        rank = row_number(),
        gdp_label = paste0(" ", round(gdpPercap, 0))
    ) %>%
    filter(rank <= 12) %>%
    ungroup()

# 3. Building the Plot
p3 <- ggplot(gapminder_ranked, aes(group = country)) + 
    geom_tile(
        aes(
            x = gdpPercap / 2, 
            y = rank, 
            width = gdpPercap, 
            height = 0.9, 
            fill = continent
        )
    ) +
    # Country Labels
    geom_text(
        aes(x = 0, y = rank, label = paste(country, " ")),
        hjust = 1, 
        size = 5,
        fontface = "bold"
    ) +
    # GDP Value Labels
    geom_text(
        aes(x = gdpPercap, y = rank, label = gdp_label),
        hjust = 0, 
        size = 4
    ) +
    # Axes
    scale_y_reverse(breaks = 1:12) +
    scale_x_continuous(labels = scales::comma) +
    scale_fill_manual(values = c(
        "Africa" = "#F8766D",
        "Americas" = "#A3A500",
        "Asia" = "#00BF7D",
        "Europe" = "#00B0F6",
        "Oceania" = "#E76BF3"
    )) +
    coord_cartesian(ylim = c(10.5, 0.5), clip = "off") + 
    labs(
        title = "Top 10 Countries by GDP per Capita",
        subtitle = "Year: {as.integer(frame_time)}", 
        x = "GDP per Capita ($)",
        y = NULL,
        fill = "Continent"
    ) +
    theme_minimal() +
    theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.y = element_blank(),
        plot.margin = margin(2, 2, 2, 6, "cm"), 
        plot.title = element_text(size = 22, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 18, hjust = 0.5, color = "gray50")
    ) +
    transition_time(year) +
    ease_aes('linear') +
    view_follow(fixed_x = TRUE)

# 4. Rendering and Saving
# visualization3_slower: nframes = 1000, fps = 10, duration = 100
# visualization3_faster: nframes = 500, fps = 20, duration = 25

anim3 <- animate(p3, renderer = gifski_renderer(), nframes = 1000, fps = 10, duration = 100, width = 800, height = 600)
anim_save("visualization3.gif", animation = anim3)