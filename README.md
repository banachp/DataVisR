# Gapminder Data Visualization

Animated visualizations exploring global development trends using the [Gapminder](https://www.gapminder.org/) dataset.

## Quick Start

```bash
Rscript analysis.R
```

This generates 4 animated GIF files in the project directory.

## Requirements

The script auto-installs missing packages. Required:
- `gapminder` - dataset
- `ggplot2`, `dplyr` - data manipulation & plotting
- `gganimate`, `gifski` - animation rendering
- `ggridges` - ridgeline plots

## Generated Visualizations

### Visualization 1: Hans Rosling Bubble Chart

![Rosling Chart](visualization1.gif)

**What it shows:** The relationship between wealth (GDP per capita) and health (life expectancy) across countries from 1952-2007.

**Key insights:**
- **Wealth-health correlation**: Higher GDP consistently associates with longer life expectancy
- **Continental patterns**: European and Oceanian countries cluster in the upper-right (rich & healthy), while African nations dominate the lower-left
- **The "Asian miracle"**: Watch Asian countries (particularly China and South Korea) dramatically shift rightward over time
- **Poland highlighted**: Tracked with a black ring to highlight poland's development trajectory

**Design elements:**
- Bubble size = population
- Log scale on x-axis to spread out lower-income countries
- Smooth animation reveals temporal trends

---

### Visualization 2: Population-Weighted Ridgeline Density Plot

![Ridgeline Plot](visualization2.gif)

**What it shows:** The distribution of life expectancy within each continent, **weighted by population**, animated over time.

**Key insights:**
- **Population-weighted**: Unlike a simple country count, this shows where *people* live — China and India heavily influence Asia's distribution
- **Africa's spread**: Large population centers at varying life expectancies create a wide distribution
- **Europe's tight peak**: Uniformly high life expectancy across similarly-sized populations
- **Asia dominated by giants**: Watch how China and India's improvements shift the entire Asian ridge rightward
- **Global convergence**: All continents shift rightward over time, representing genuine improvement in human welfare

**Design elements:**
- Ridge height = population density at that life expectancy
- Larger countries have proportionally more influence
- Color-coded by continent for quick identification

## Output Files

| File                      | Dimensions     | Description                  |
| ------------------------- | -------------- | ---------------------------- |
| `visualization1.gif`      | Standard       | Rosling bubble chart         |
| `visualization1_wide.gif` | 800×450 (16:9) | Rosling chart for widescreen |
| `visualization2.gif`      | Standard       | Ridgeline density plot       |
| `visualization2_wide.gif` | 800×450 (16:9) | Ridgeline for widescreen     |

## Data Source

The `gapminder` package contains an excerpt of data from [Gapminder.org](https://www.gapminder.org/), covering 142 countries across 5 continents from 1952 to 2007 (every 5 years).

Variables: `country`, `continent`, `year`, `lifeExp`, `pop`, `gdpPercap`
