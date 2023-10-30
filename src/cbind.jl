using DataFrames: hcat

# abind(args...; along=3) = cat(args..., dims=along)
rbind(args...) = cat(args..., dims=1)


include("cbind_helper.jl")
# cbind = hcat # not work
# cbind(args...) = cat(args..., dims = 2)
function cbind end

function cbind(x::AbstractDataFrame, y::AbstractDataFrame)
  hcat(x, y; makeunique=true)
end

AbstractDataFramable = Union{AbstractDataFrame,AbstractVecOrMat}

cbind(x::AbstractDataFrame, y::AbstractDataFramable) where {} =
  hcat(as_DT(x), as_DT(y); makeunique=true)

cbind(x::AbstractDataFramable, y::AbstractDataFrame) where {} =
  hcat(as_DT(x), as_DT(y); makeunique=true)

cbind(x::AbstractVecOrMat, y::AbstractVecOrMat) = 
  hcat(x, y)

# scalar or vector
function cbind_x(df, val, key)
  N = nrow(df)
  n = length(val)
  if n > 1 && n < N
    val = repeat(val, cld(N, n))
    if length(val) != n
      @warn "$key recycled with remainder"
      val = val[1:N]
    end
  end
  df[!, key] .= val
  df
end

# 多个的排序只接受这一种
function cbind(; deepcopy=false, kw...)
  df, keys, vals, names = get_kw_DF(; kw...)
  
  isempty(df) && return kw
  
  deepcopy && (df = Base.deepcopy(df))
  for i in eachindex(keys)
    cbind_x(df, vals[i], keys[i])
  end

  if length(unique(names)) == length(names) 
    df = df[:, Cols(names)]
  end
  df
end


function cbind(x::AbstractDataFramable, args...)
  if length(args) == 0
    x
  elseif length(args) == 1
    cbind(x, args[1])
  else
    cbind(cbind(x, args[1]), args[2:end]...)
  end
end

# args: 只能是 DataFrame 或者 matrix
function cbind(args...; kw...)
  r1 = cbind(args...)
  cbind(; __=as_DT(r1), kw...)
end

export cbind, rbind

# # rbind = vcat
# rbind(args...; kw...) = vcat(args...; kw...)
# rbind(x) = x
# rbind(x::DataFrame,
#     y::Union{DataFrame,AbstractVecOrMat}; kw...) = begin
#     # @assert (ncol(x) == ncol(y))
#     x = as_DT(x)
#     y = as_DT(y, names(x))
#     vcat(x, y; kw...)
# end

# rbind(x::AbstractVecOrMat, y::DataFrame; kw...) = rbind(as_DT(x, names(y)), y; kw...)

# function rbind(x::DataFrame, args...; kw...)
#     x = as_DT(x)
#     if length(args) == 0
#         x
#     elseif length(args) == 1
#         rbind(x, args[1])
#     else
#         rbind(rbind(x, args[1]), args[2:end]...)
#     end
# end
