@testset "melt_list" begin
  probs = [0.90, 0.95, 0.99, 0.999, 0.9999]
  levs = probs

  d = DataFrame(x=1:40)
  names(d)

  d2 = cbind(d, prob=probs[1])
  @test names(d2) == ["x", "prob"]

  ## for data.frame melt_list
  l = []
  for i = 1:4
    push!(l, deepcopy(d)) # need to deep copy
  end
  df1 = melt_list(l, id=1:4)
  # l = [d, d, d, d]

  df1 = melt_list(l, id=1:4)
  @test unique(df1.id) == [1, 2, 3, 4]
  
  df2 = melt_list(l)
  @test unique(df2.I) == [1, 2, 3, 4]

  ## test for multi
  df3 = melt_list(l, id=1:4, probs=[0.9, 0.95, 0.99, 0.999]);
  df3 = melt_list(l, id=1:4, probs=0.9)

  # test for empty list
  push!(l, [])
  df3 = melt_list(l)
  @test names(df2) == ["I", "x", "prob", "id"]
end

# @pipe d |> groupby(:y)
# `>(6)` has to in this format
# @pipe df |>
#       dropmissing |>
#       filter(:id => >(6), _) |>
#       groupby(:group) |>
#       combine(:age => sum)

# @pipe df |>
#       dropmissing |>
#       filter(:id => >(6), _)


# @testset "@subset" begin
#     x = 1:2
#     y = 2
#     dt = data.table(; x, y=[2, 3], z=[1, 3])

#     @test typeof(dt) == DataFrame
#     @test @subset(dt, y == 2) |> nrow == 1
#     @test @subset(dt, y == 1) |> nrow == 0
#     @test @subset(dt, y == 2 & z == 1) |> nrow == 1

#     # works for global variable
#     y0 = 2
#     @test @pipe(dt |> @subset(y == 2, true)) == @pipe(dt |> @subset(y == y0, true))
# end
