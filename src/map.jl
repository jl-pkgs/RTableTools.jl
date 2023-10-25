function map_df(fun::Function, lst::GroupedDataFrame{DataFrame}, args...; kw...)
  n = length(lst)
  map(i -> fun(lst[i], args...; kw...), 1:n)
end

export map_df
