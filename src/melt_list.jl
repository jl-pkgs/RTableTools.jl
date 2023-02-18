# for data.frame by reference operation
function melt_list(list; kw...)
  if length(kw) > 0
    by = keys(kw)[1]
    vals = kw[1]
  else
    by = :I
    vals = 1:length(list)
  end

  for i = eachindex(list)
    d = list[i]
    if (d isa DataFrame)
      d[:, by] .= vals[i]
    end
  end
  ind = map(is_dataframe, list)
  vcat(list[ind]...)
end


precompile(melt_list, (Vector{DataFrame},))
