module RTableTools


using DocStringExtensions: TYPEDSIGNATURES
using DataFrames
using CSV
using Reexport

@reexport using TidierData
# include("wip/con_parse.jl")
# include("wip/macro.jl")

include("cbind.jl")

include("data.frame.jl")
include("merge.jl")
include("melt_list.jl")

include("IO.jl")
include("expand_grid.jl")
include("tools.jl")
include("tools_Tidier.jl")

include("precompile.jl")



export rbind, cbind, melt_list,
  fread, fwrite, dt_merge,
  @subset
  DataFrame, DF, names,
  datatable, dataframe


end # module RTableTools
