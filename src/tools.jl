using DataFrames: sort
import Base: NamedTuple


# - `x`: returned by `Ipaper.table`
function table2df(x)
  DataFrame(; key=collect(keys(x)), count=collect(values(x))) |>
    d -> sort(d, :count, rev=true)
end

function Base.NamedTuple(names::Vector, values::Vector)
  NamedTuple{Tuple(Symbol.(names))}(values)
end

export table2df, NT
