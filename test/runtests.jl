using Test
using RTableTools
using DataFrames

# println(dirname(@__FILE__))
# println(pwd())

# cd(dirname(@__FILE__)) do

# include("test-Ipaper.jl")
# include("test-missing.jl")
# include("test-quantile.jl")
# include("test-Pipe.jl")
include("test-dt.jl")
include("test-melt_list.jl")
include("test-cbind.jl")

# include("test-list.jl")
# include("test-date.jl")
# include("test-apply.jl")
# include("test-smooth_whit.jl")
# include("test-smooth_SG.jl")
# include("test_wTSM.jl")
# include("test_whittaker.jl")
# include("test-lambda_init.jl")
# end
