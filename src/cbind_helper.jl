# @show map_pairs(is.data.frame, kw)
function map_pairs(f, x::Base.Pairs)
  [f(val) for (key, val) in x]
end


function get_df_names(; kw...)
  names = []
  for (key, val) in kw
    name = (is.data.frame(val)) ? Base.names(val) : string(key)
    push!(names, name)
  end
  cat(names..., dims=1)
end


function get_kw_DF(; makeunique=true, kw...)
  vals = [k.second for k in kw]
  keys = [k.first for k in kw]

  lgl = map(is.data.frame, vals)
  df = []

  if sum(lgl) > 0
    l_df = vals[lgl]
    keys = keys[.!lgl]
    vals = vals[.!lgl]
    df = length(l_df) == 1 ? l_df[1] : hcat(l_df...; makeunique)
  end

  names = get_df_names(; kw...)
  df, keys, vals, names
end


function get_args_DF(args; makeunique=true)
  lgl = map(is.data.table, args) |> collect
  df = l_df = []
  if sum(lgl) > 0
    ind = findall(lgl)
    for i in ind
      push!(l_df, args[i])
    end
    df = length(l_df) == 1 ? l_df[1] : hcat(l_df...; makeunique)
  end
  df, args[.!lgl]
end


export map_pairs
