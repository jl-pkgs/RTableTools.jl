module Tidytable2


using DocStringExtensions: TYPEDSIGNATURES

using DataFrames
using CSV


include("macro.jl")
include("cbind.jl")

include("data.frame.jl")
include("merge.jl")
include("melt_list.jl")

include("con_parse.jl")

include("IO.jl")
include("expand_grid.jl")
include("tools.jl")

include("precompile.jl")



export rbind, cbind, abind, melt_list,
  fread, fwrite, dt_merge,
  @subset
  DataFrame, DF, names,
  datatable, dataframe


end # module Tidytable2
