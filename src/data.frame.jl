

as_matrix(x::AbstractDataFrame) = Matrix(x)

as_dataframe(x::AbstractDataFrame, args...) = x
as_dataframe(x::AbstractVector) = @as_df(x)

as_dataframe(x::AbstractMatrix) = DataFrame(x, :auto)
function as_dataframe(x::AbstractVecOrMat, names::AbstractVector; kw...)
  DataFrame(x, names; kw...)
end

is_dataframe(d) = d isa DataFrame

# for data.frame by reference operation
function dataframe(; kw...)
  DataFrame(pairs(kw))
end
datatable = dataframe

# function list(; kw...)
#     Dict(pairs(kw))
# end

"""
    match2(x, y)

# Examples
```julia
## original version
mds = [1, 4, 3, 5]
md = [1, 5, 6]

findall(indexin(mds, md) .!= nothing)
indexin(md, mds)

## modern version
x = [1, 2, 3, 3, 4]
y = [0, 2, 2, 3, 4, 5, 6]
match2(x, y)
```

# Note: match2 only find the element in `y`
"""
function match2(x, y)
  # find x in y
  ind = indexin(x, y)
  I_x = which_notna(ind)
  I_y = something.(ind[I_x])
  # use `something` to suppress nothing `Union`
  DataFrame(; value=x[I_x], I_x, I_y)
end

#! This version not work
# function datatable(args...; kw...)
#     params = args..., kw...
#     datatable(; params...)
# end
const DF = dataframe;
