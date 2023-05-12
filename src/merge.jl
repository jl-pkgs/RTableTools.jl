"""
    $(TYPEDSIGNATURES)

```julia
d1 = DataFrame(A=1:3, B=4:6, C=7:9)
d2 = DataFrame(A=1:3, B=4:6, D=7:9)
d = dt_merge(d1, d2, by = "A", suffixes=["_tas", ".rh"])
d[:, "B.rh"]
```

seealso: [`leftjoin`](@ref), [`rightjoin`](@ref), [`innerjoin`](@ref), 
    [`outerjoin`](@ref)
"""
function dt_merge(x::AbstractDataFrame, y::AbstractDataFrame; by=nothing,
  all=false, all_x=all, all_y=all, makeunique=true, suffixes=["_x", "_y"], kw...)

  if by === nothing
    by = intersect(names(x), names(y))
  end
  by = String.(by) # Symbol not work in `setdiff`

  vars_dup = intersect(setdiff(names(x), by), setdiff(names(y), by))

  rename_x(x) = rename_varsDup(x, vars_dup, suffixes[1])
  rename_y(x) = rename_varsDup(x, vars_dup, suffixes[2])
  kw2 = (kw..., on=by, makeunique, renamecols=rename_x => rename_y)
  # @show kw2
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

# rename Duplicate variables in dt_merge
rename_varsDup(x::AbstractString, vars_dup::Vector, suffix="_x") = x in vars_dup ? x * suffix : x
