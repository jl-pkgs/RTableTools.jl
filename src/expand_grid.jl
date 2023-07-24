using DataFrames


"""
    expand_grid(; kw...)
    
Create a Data Frame from All Combinations of Factor Variables (see R's base::expand.grid)

# Return
A DataFrame containing one row for each combination of the supplied argument. The first factors vary fastest.

# Examples
```julia
julia> dims = (x = 1:2, y = [3, 4], z = ["a", "b", "c"]);

julia> expand_grid(;dims...)
12×3 DataFrame
 Row │ x      y      z      
     │ Int64  Int64  String 
─────┼──────────────────────
   1 │     1      3  a
   2 │     2      3  a
   3 │     1      4  a
   4 │     2      4  a
   5 │     1      3  b
   6 │     2      3  b
   7 │     1      4  b
   8 │     2      4  b
   9 │     1      3  c
  10 │     2      3  c
  11 │     1      4  c
  12 │     2      4  c
```
"""
function expand_grid(; kw...)
  # names = keys(kw) |> collect
  # nargs = length(kw)
  # nobs = prod(map(length, values))
  # for i in 1:nargs
  #   x = values[i]
  #   nx = length(x)
  #   np = Int(nobs / nx)
  #   values[i] = repeat(x, np)
  # end
  # DataFrame(values, names)
  values = [v for (_, v) in kw]
  names = keys(kw) |> collect
  DataFrame(collect(Iterators.product(values...))[:], names)
end



"""
    array2df(A, dims)

# Examples
```julia
julia> dims = (x = 1:2, y = [3, 4], z = ["a", "b", "c"]);
julia> A = rand(2, 2, 3);
julia> array2df(A, dims)
12×4 DataFrame
 Row │ x      y      z       value    
     │ Int64  Int64  String  Float64  
─────┼────────────────────────────────
   1 │     1      3  a       0.62047  
   2 │     2      3  a       0.669467 
   3 │     1      4  a       0.198138 
   4 │     2      4  a       0.522508 
   5 │     1      3  b       0.320988 
   6 │     2      3  b       0.198885 
   7 │     1      4  b       0.780293 
   8 │     2      4  b       0.892373 
   9 │     1      3  c       0.716294 
  10 │     2      3  c       0.562014 
  11 │     1      4  c       0.834089 
  12 │     2      4  c       0.37194  
```
"""
function array2df(A::AbstractArray, dims)
  _size = map(length, dims) |> values
  @assert size(A) == _size "The length of dims should equal to `size(A)`!"

  d = expand_grid(; dims...)
  # iter = Iterators.product(kw...)
  d.value = Vector{eltype(A)}(undef, length(A))
  for i = eachindex(A)
    d.value[i] = A[i]
  end
  d
end


export expand_grid, array2df
