using DataFrames: sort


# - `x`: returned by `Ipaper.table`
function table2df(x)
  DataFrame(; key=collect(keys(x)), count=collect(values(x))) |>
    d -> sort(d, :count, rev=true)
end


export table2df
