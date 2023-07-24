using DataFrames
using DataFrames: nrow, ncol

DataFrames.nrow(x::AbstractArray) = size(x, 1)
DataFrames.ncol(x::AbstractArray) = size(x, 2)

# rbind(args...) = cat(args..., dims = 1)
# cbind(args...) = cat(args..., dims = 2)
abind(args...; along=3) = cat(args..., dims=along)

# # rbind = vcat
rbind(args...; kw...) = vcat(args...; kw...)
# rbind(x) = x
# rbind(x::DataFrame,
#     y::Union{DataFrame,AbstractVecOrMat}; kw...) = begin
#     # @assert (ncol(x) == ncol(y))
#     x = as_dataframe(x)
#     y = as_dataframe(y, names(x))
#     vcat(x, y; kw...)
# end

# rbind(x::AbstractVecOrMat, y::DataFrame; kw...) = rbind(as_dataframe(x, names(y)), y; kw...)

# function rbind(x::DataFrame, args...; kw...)
#     x = as_dataframe(x)
#     if length(args) == 0
#         x
#     elseif length(args) == 1
#         rbind(x, args[1])
#     else
#         rbind(rbind(x, args[1]), args[2:end]...)
#     end
# end

# cbind = hcat # not work
cbind(args...; kw...) = hcat(args...; kw...)
cbind(x) = x
cbind(x::AbstractDataFrame, y::Union{AbstractDataFrame,AbstractVecOrMat}) =
  hcat(as_dataframe(x), as_dataframe(y); makeunique=true)
cbind(x::AbstractVecOrMat, y::AbstractDataFrame; kw...) = cbind(as_dataframe(x), y; kw...)

# by reference
function cbind(x::AbstractDataFrame, args...; kw...)
  x = as_dataframe(x)
  n = length(kw)
  if n > 0
    vars = keys(kw)
    for i = 1:n
      key = vars[i]
      val = kw[i]
      # @show key
      # @show val
      if !isa(val, AbstractArray) || length(val) == 1
        x[:, key] .= val
      else
        x[:, key] = val
      end
    end
  end
  if length(args) == 0
    x
  elseif length(args) == 1
    cbind(x, args[1])
  else
    cbind(cbind(x, args[1]), args[2:end]...)
  end
end
