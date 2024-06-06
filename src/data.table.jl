using DataFrames
using DataFrames: sort

# extend for array
DataFrames.nrow(x::AbstractArray) = size(x, 1)
DataFrames.ncol(x::AbstractArray) = size(x, 2)


## module: data ================================================================
module data
global table, frame
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
global table
function frame end
end
end

# only for vector
macro as_DF(x)
  name = string(x)
  expr = :(as.data.frame($x, $name))
  esc(expr)
end

as.matrix(x::AbstractDataFrame) = Matrix(x)

function as.data.frame(x::Dict)
  d = DataFrame(; key=collect(keys(x)), value=collect(values(x)))
  sort(d, :key)
end

# 未定义的部分
as.data.frame(x, kw...) = x
as.data.frame(x::AbstractVector) = DataFrame(:x => x)
as.data.frame(x::AbstractVector, name) = DataFrame(name => x)

as.data.frame(x::AbstractMatrix) = DataFrame(x, :auto)
function as.data.frame(x::AbstractMatrix, names)
  if ncol(x) == length(names)
    DataFrame(x, names)
  else
    DataFrame(x, :auto)
  end
end


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

export @as_DF;
export set_names, get_names
export DT, DF, as_DF, as_DT
export data, as, is
export nrow, ncol
