import DataFrames: sort

macro as_df(x)
  name = string(x)
  expr = :(DataFrame($name => $x))
  esc(expr)
end
export @as_df;


as_matrix(x::AbstractDataFrame) = Matrix(x)

as_dataframe(x::AbstractDataFrame, args...) = x
as_dataframe(x::AbstractVector) = @as_df(x)

as_dataframe(x::AbstractMatrix) = DataFrame(x, :auto)
function as_dataframe(x::AbstractVecOrMat, names::AbstractVector; kw...)
  DataFrame(x, names; kw...)
end

function as_dataframe(x::Dict)
  d = DataFrame(;key = collect(keys(x)), value = collect(values(x))) 
  sort(d, :key)
end

as_datatable = as_dataframe

is_dataframe(d) = d isa DataFrame


export is_dataframe,
  @as_df,
  as_dataframe, as_datatable,
  as_matrix, nrow, ncol
