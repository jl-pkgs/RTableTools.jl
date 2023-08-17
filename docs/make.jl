using Documenter, RTableTools
using DataFrames


CI = get(ENV, "CI", nothing) == "true"

# Logging.disable_logging(Logging.Warn)

# Make the docs, without running the tests again
# We need to explicitly add all the extensions here
makedocs(
  modules=[
    RTableTools
  ],
  format=Documenter.HTML(
    prettyurls=CI,
  ),
  # pages=[
  #   "Introduction" => "index.md",
  #   "Meteorology" => "Meteorology.md",
  #   "Hydrology" => "Hydrology.md",
  #   "Potential Evapotranspiration models" => "PET.md",
  #   "Extreme Climate indexes" => "ExtremeClimate.md"
  # ],
  sitename="RTableTools.jl",
  strict=false,
  clean=false,
)

# Enable logging to console again
# Logging.disable_logging(Logging.BelowMinLevel)

deploydocs(
  repo="github.com/jl-spatial/RTableTools.jl.git", 
)
