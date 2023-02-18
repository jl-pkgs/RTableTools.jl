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
