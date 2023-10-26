# for data.frame by reference operation
"""
    melt_list(list; deepcopy=false, kw...)

# Arguments

- `list`: list of DataFrames

# Examples
```julia
d = data.table(; x=1, y=2)
l = [d, d, d, d]

r1 = melt_list(l, id=1:4) # id all is 4
r2 = melt_list(l, id=1:4, deepcopy=true)

melt_list(l; a = 1, b = 2)
```
"""
function melt_list(list; deepcopy=false, kw...)
  if length(kw) > 0
    by = keys(kw) |> collect
    vals = kw
  else
    by = [:I]
    vals = [1:length(list)]
  end

  deepcopy && (list = map(Base.deepcopy, list))
  
  for k in eachindex(by)
    _val = vals[k]
    _by = by[k]  

    for i = eachindex(list)
      d = list[i]
      if (d isa DataFrame)
        _value = isa(_val, AbstractVector) ? _val[i] : _val
        d[!, _by] .= _value
      end
    end
  end

  ind = map(is.data.frame, list)
  r = vcat(list[ind]...)
  r[:, Cols(by, 1:end)]
end
