using DataFrames
using DataFrames: sort

# extend for array
DataFrames.nrow(x::AbstractArray) = size(x, 1)
DataFrames.ncol(x::AbstractArray) = size(x, 2)


## module: data ================================================================
module data
end
data.table = DataFrame
data.frame = DataFrame

const DT = data.table;
const DF = data.table;

#! This version not work
# function data.table(args...; kw...)
#     params = args..., kw...
#     data.table(; params...)
# end

# function list(; kw...)
#     Dict(pairs(kw))
# end

## module: as ==================================================================
module as

function matrix end

module data
function frame end
end
end

# only for vector
macro as_df(x)
  name = string(x)
  expr = :(DataFrame($name => $x))
  esc(expr)
end

as.matrix(x::AbstractDataFrame) = Matrix(x)

function as.data.frame(x::Dict)
  d = DataFrame(; key=collect(keys(x)), value=collect(values(x)))
  sort(d, :key)
end

as.data.frame(x::AbstractDataFrame, args...) = x
as.data.frame(x::AbstractVector) = @as_df(x)
as.data.frame(x::AbstractMatrix) = DataFrame(x, :auto)

as.data.frame(x::AbstractVecOrMat, names::AbstractVector; kw...) =
  DataFrame(x, names; kw...)

as.data.table = as.data.frame

as_DT = as.data.table
as_DF = as.data.frame

## MODULE: IS ==================================================================
module is
module data
function table end
function frame end
end
end

is.data.table(d) = d isa AbstractDataFrame
is.data.frame(d) = d isa AbstractDataFrame


function get_names(l::GroupedDataFrame; sep=nothing)
  names = values.(keys(l)) |> collect
  sep !== nothing && (names = Base.join.(names, sep))
  names
end

set_names(d::AbstractDataFrame, names) = rename!(d, names)

export @as_df;
export set_names, get_names
export DT, DF, as_DF, as_DT
export data, as, is
export nrow, ncol
