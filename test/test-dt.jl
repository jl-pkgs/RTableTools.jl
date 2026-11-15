# using Ipaper
using Test
# @subset(dt, y == 2)

@testset "merge" begin
  d1 = DataFrame(A=1:3, B=4:6, C=7:9)
  d2 = DataFrame(A=1:3, B=4:6, D=7:9)

  r1 = merge(d1, d2, by = [:A])
  r2 = merge(d1, d2, by = ["A"])
  @test r1 == r2
  r3 = merge(d1, d2, by = :A, suffixes=["_tas", ".rh"])
  r4 = merge(d1, d2, by = "A", suffixes=["_tas", ".rh"])
  @test length(r4[:, "B.rh"]) == 3
end

@testset "Arrow IO" begin
  mktempdir() do dir
    df = DataFrame(A=[1, missing, 3], B=["a", "b", "c"])
    for ext in ("arrow", "ARROW")
      file = joinpath(dir, "nested", "data.$ext")
      fwrite(df, file; compress=:zstd)
      @test isequal(fread(file), df)
      @test_throws ArgumentError fwrite(df, file; append=true)
      @test isequal(fread(file), df)
    end
  end
end

@testset "fwrite" begin
  df = DataFrame(A=1:3, B=4:6, C=7:9)
  fwrite(df, "a.csv")
  fwrite(df, "a.csv", append=true)

  df = fread("a.csv")
  @test nrow(df) == 6
  rm("a.csv")
end
