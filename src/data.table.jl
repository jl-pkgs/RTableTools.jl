export data
module data

using DataFrames

table = DataFrame
frame = DataFrame

end

#! This version not work
# function data.table(args...; kw...)
#     params = args..., kw...
#     data.table(; params...)
# end

# for data.frame by reference operation
# function data.frame(; kw...)
#   DataFrame(pairs(kw))
# end

# function list(; kw...)
#     Dict(pairs(kw))
# end
const DT = data.table;
const DF = data.table;

function get_names(l::GroupedDataFrame; sep=nothing)
  names = values.(keys(l)) |> collect
  sep !== nothing && (names = Base.join.(names, sep))
  names
end

set_names(d::AbstractDataFrame, names) = rename!(d, names)


export set_names, get_names
export DT, DF
