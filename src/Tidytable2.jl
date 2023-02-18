module Tidytable2


using DocStringExtensions: TYPEDSIGNATURES

using DataFrames
using CSV


include("data.frame.jl")
include("con_parse.jl")
include("subset.jl")

include("IO.jl")


end # module Tidytable2
