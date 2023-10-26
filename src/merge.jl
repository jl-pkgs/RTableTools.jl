import DataFrames: leftjoin, rightjoin, innerjoin, outerjoin


# rename Duplicate variables
rename_vars_duplicated(x::AbstractString, vars_dup::Vector, suffix="_x") = 
  x in vars_dup ? x * suffix : x

"""
    $(TYPEDSIGNATURES)

# Example
```julia
d1 = DataFrame(A=1:3, B=4:6, C=7:9)
d2 = DataFrame(A=1:3, B=4:6, D=7:9)
d = merge(d1, d2, by = "A", suffixes=["_tas", ".rh"])
d[:, "B.rh"]
```

seealso: `leftjoin`, `rightjoin`, `innerjoin`, `outerjoin`
"""
function Base.merge(x::AbstractDataFrame, y::AbstractDataFrame; by=nothing,
  all=false, all_x=all, all_y=all, makeunique=true, suffixes=["_x", "_y"], kw...)

  if by === nothing
    by = intersect(names(x), names(y))
  end
  by = String.(by) # Symbol not work in `setdiff`

  vars_dup = intersect(setdiff(names(x), by), setdiff(names(y), by))
  rename_x(x) = rename_vars_duplicated(x, vars_dup, suffixes[1])
  rename_y(x) = rename_vars_duplicated(x, vars_dup, suffixes[2])
  kw2 = (;kw..., on=by, makeunique, renamecols=rename_x => rename_y)
  
  if !all
    if all_x
      leftjoin(x, y; kw2...)
    elseif all_y
      rightjoin(x, y; kw2...)
    else
      # all_x = f && all_y = f
      innerjoin(x, y; kw2...)
    end
  else
    outerjoin(x, y; kw2...)
  end
end

dt_merge = Base.merge
