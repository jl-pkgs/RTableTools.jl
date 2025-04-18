using DataFrames: hcat
export _cbind
export cbind, rbind

# abind(args...; along=3) = cat(args..., dims=along)
rbind(args...) = cat(args..., dims=1)


include("cbind_helper.jl")
# cbind = hcat # not work
# cbind(args...) = cat(args..., dims = 2)
AbstractDataFramable = Union{AbstractDataFrame,AbstractVecOrMat}

function cbind(x::Tx, y::Ty) where {
  Tx<:AbstractDataFramable,Ty<:AbstractDataFramable}
  if Tx <: AbstractDataFrame || Ty <: AbstractDataFrame
    hcat(as_DT(x), as_DT(y); makeunique=true)
  else
    hcat(x, y)
  end
end

# scalar or vector
function _cbind(df::AbstractDataFrame, key::Symbol, val; head=true)
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
  df[!, Cols(key, 1:end)]
end

# 多个的排序只接受这一种
function cbind(; deepcopy=false, kw...)
  df, keys, vals, names = get_kw_DF(; kw...)
  isempty(df) && return kw

  deepcopy && (df = Base.deepcopy(df))
  for i in eachindex(keys)
    _cbind(df, keys[i], vals[i])
  end

  # 若命名无重复，则尝试修复
  if length(unique(names)) == length(names)
    df = df[:, Cols(names)]
  end
  df
end


function cbind(x::AbstractDataFramable, args...)
  isempty(args) && return x
  foldl((a, b) -> cbind(a, b), args; init = x)
end

# args: 只能是 DataFrame 或者 matrix
function cbind(args...; kw...)
  r1 = cbind(args...)
  cbind(; __=as_DT(r1), kw...)
end
