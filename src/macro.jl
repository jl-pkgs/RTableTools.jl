# Base.Regex(x::Regex) = x
StringOrRegex = Union{AbstractString,Regex}

"""
    str_extract(x::AbstractString, pattern::AbstractString)
    str_extract(x::Vector{<:AbstractString}, pattern::AbstractString)

    str_extract_all(x::AbstractString, pattern::AbstractString)
"""
function str_extract(x::AbstractString, pattern::StringOrRegex)
    r = match(Regex(pattern), x)
    r === nothing ? "" : r.match
end

function str_extract(x::Vector{<:AbstractString}, pattern::StringOrRegex)
    str_extract.(x, pattern)
end

function str_extract_all(x::AbstractString, pattern::StringOrRegex)
    [x === nothing ? "" : x.match for x in eachmatch(Regex(pattern), x)]
end

str_extract_strip(x::AbstractString, pattern::StringOrRegex) =
    strip(str_extract(x, pattern))



macro subset(d, con, verbose=false)
  # @show d, typeof(d)
  dname = string(d)
  con = string(con)
  # @show dname, con

  expr = con_dt_transform(con; dname=dname)
  verbose && @show expr
  esc(Meta.parse(expr))
end

macro as_df(x)
  name = string(x)
  expr = :(DataFrame($name => $x))
  esc(expr)
end


export @subset
export @as_df;
