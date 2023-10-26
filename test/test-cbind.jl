using Test
using RTableTools
using DataFrames

df = data.table(; id=1:10, group=repeat([1, 2], 5), age=12)
mat = as.matrix(df)

@testset "cbind" begin
  # mat = as_matrix(df)
  @test typeof(cbind(mat, mat, mat)) == Matrix{Int64}
  @test_nowarn cbind(id=1:10, df, df)
  @test_nowarn cbind(id=1:10, df, as.matrix(df))
  @test_nowarn cbind(id=1:10, as.matrix(df), df)
end

DF(mat, :auto)
DF(mat, [:a, :b, :c])
