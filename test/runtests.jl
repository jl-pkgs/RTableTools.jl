using RTableTools, DataFrames, Test
import RTableTools: getDataType

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

@testset "array2df" begin
  dims = (x=1:2, y=[3, 4], z=["a", "b", "c"])
  A = rand(2, 2, 3)
  d = array2df(A, dims)

  _names = [:x, :y, :z]
  _dims, _A = df2array(d, [:x, :y, :z], :value)
  _dims, _A = df2array(d, string.([:x, :y, :z]), "value")
  @test _A == A
  @test _dims == dims
end


@testset "replace_missing!" begin
  x = [1, 2, 3, missing]
  y = [1, 2, 3., missing]

  d = DataFrame(; x, y)
  replace_missing!(d)
  @test eltype(d.x) == Union{Missing,Int64}
  @test eltype(d.y) == Float64

  d = DataFrame(; x, y)
  replace_missing!(d, 0) ## 整型无NaN
  @test eltype(d.x) == Int64
  @test eltype(d.y) == Float64
end
