# https://github.com/TidierOrg/TidierData.jl/issues/37#issuecomment-1703855098
"""
  @replace_missing(df, kwargs...)

## Examples
```
# @replace_missing(df, a = 0, b = 2, c = "wow")
```
"""
macro replace_missing(df, kwargs...)
  expressions = []
  for kwarg in kwargs
    if kwarg.head == :(=)
      key = kwarg.args[1]
      value = kwarg.args[2]
      push!(expressions, :($(key) = coalesce($(key), $value)))
    else
      throw(ArgumentError("Invalid argument: $kwarg"))
    end
  end
  return quote
    @mutate($(esc(df)), $(expressions...))
  end
end


export @replace_missing
