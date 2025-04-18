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


"""
    df2array(df, dim_cols, val_col)

Convert a DataFrame to an N-dimensional array.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `dim_cols::Vector{Symbol}`: The columns to be used as dimensions.
- `val_col::Symbol`: The column to be used as the value.

# Return
An N-dimensional array.

# Examples
```julia
julia> df = DataFrame(x = [1, 1, 2, 2], y = [3, 4, 3, 4], value = [0.1, 0.2, 0.3, 0.4]);
julia> df2array(df, [:x, :y], :value)
2×2 Array{Float64,2}:
 0.1  0.2
 0.3  0.4
```
"""
function df2array(df::DataFrame, dim_cols::Vector{S}, val_col::S) where {S<:Union{Symbol, String}}
  # 1. 原来的维度值、大小和映射表
  dim_values = [sort(unique(df[!, col])) for col in dim_cols]
  dims_size = length.(dim_values)
  maps = [Dict(v => i for (i, v) in enumerate(vals)) for vals in dim_values]
  
  # 2. 输出数组
  T = eltype(df[!, val_col])
  data = Array{T}(undef, dims_size...)
  
  # 3. 直接拿出列向量，避免 eachrow 的开销
  colvecs = [df[!, col] for col in dim_cols]
  valvec = df[!, val_col]
  nd = length(dim_cols)
  
  # 4. 用 ntuple+CartesianIndex + @inbounds 索引赋值，零分配
  @inbounds for i in eachindex(valvec)
    idxs = ntuple(j -> maps[j][colvecs[j][i]], nd)
    data[CartesianIndex(idxs)] = valvec[i]
  end

  dims = NamedTuple(dim_cols, dim_values)
  dims, data
end



export expand_grid, array2df
export df2array
