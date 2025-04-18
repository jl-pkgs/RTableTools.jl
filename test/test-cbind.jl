using RTableTools, DataFrames, Test

df = data.table(; id=1:10, group=repeat([1, 2], 5), age=12)
mat = as.matrix(df)

as_DF(mat)
as_DF(mat, [:a, :b, :c])

## mainly depend on cbind(; kw...)
@testset "cbind matrix" begin
  # mat = as_matrix(df)
  @test typeof(cbind(mat, mat, mat)) == Matrix{Int64}
  cbind(mat, mat)
  cbind(rand(4), rand(4, 4))
  cbind(rand(4), rand(4, 4), rand(4, 2))
end

@testset "cbind data.frame" begin
  @test_nowarn cbind(I=1:10, df, df)
  @test_nowarn cbind(I=1:10, df, as.matrix(df))
  @test_nowarn cbind(I=1:10, as.matrix(df), df)
end


# order matters
@testset "cbind variable order" begin
  d = DT(val=1:4)
  @test names(cbind(; x=1:4, d, z=2:5, deepcopy=true)) == ["x", "val", "z"]
    
  # matrix需要输入名字
  d = DT(val=1:4)
  cbind(; x=1, d, y=as_DT(rand(4, 4)), deepcopy=true)
  # cbind(; x=1, d, y=rand(4, 4), deepcopy=true) # error
end
