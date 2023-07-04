Base.Regex(x::Regex) = x
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
