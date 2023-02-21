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

#! This version not work
# function datatable(args...; kw...)
#     params = args..., kw...
#     datatable(; params...)
# end
const DF = dataframe;
