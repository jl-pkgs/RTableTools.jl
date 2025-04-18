# https://github.com/TidierOrg/TidierData.jl/issues/37#issuecomment-1703855098
# """
#   @replace_missing(df, kwargs...)

# ## Examples
# ```
# # @replace_missing(df, a = 0, b = 2, c = "wow")
# ```
# """
# macro replace_missing(df, kwargs...)
#   expressions = []
#   for kwarg in kwargs
#     if kwarg.head == :(=)
#       key = kwarg.args[1]
#       value = kwarg.args[2]
#       push!(expressions, :($(key) = coalesce($(key), $value)))
#     else
#       throw(ArgumentError("Invalid argument: $kwarg"))
#     end
#   end
#   return quote
#     @mutate($(esc(df)), $(expressions...))
#   end
# end
# export @replace_missing

# # 可以含有missing、也可以不含有
# AbstractMissOrRealArray = AbstractArray{<:Union{T,Missing}} where {T<:Real}
# # 必须含有missing
# AbstractMissArray = AbstractArray{Union{T,Missing}} where {T<:Real}

function drop_missing(x::AbstractArray{Union{T,Missing}}, replacement=NaN) where {T<:Real}
  x2 = replace(x, missing => T(replacement))
  Array{T}(x2)
end

drop_missing(x::AbstractArray{<:Real}, replacement=NaN) = x


function getDataType(x)
  T = eltype(x)
  typeof(T) == Union ? T.b : T
end

function replace_missing!(df::AbstractDataFrame, replacement::T=NaN) where {T<:Real}
  TYPE = T <: Integer ? Real : AbstractFloat

  # colnames = names(df)
  # num_cols = [name for name in colnames if getDataType(df[!, name]) <: Number]
  for col in names(df)
    x = df[!, col]
    type = getDataType(x)

    if type <: TYPE
      df[!, col] = drop_missing(x, replacement)
    end
  end
  df
end


export replace_missing!
