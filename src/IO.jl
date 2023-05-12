import CSV


# whether directory exist? If not, create it.
function check_dir(indir; verbose=false)
  if (!isdir(indir))
    mkpath(indir)
    false
  else
    verbose && printstyled("[warn] dir exists: $indir\n"; color=:light_black)
    true
  end
end



fread(file::AbstractString) = DataFrame(CSV.File(file))

"""
    fwrite(df, file; kw...)

```julia
df = DataFrame(A=1:3, B=4:6, C=7:9)
fwrite(df, "a.csv")
fwrite(df, "a.csv", append=true)

fread("a.csv")
```
"""
fwrite(df::AbstractDataFrame, file::AbstractString; append=false, kw...) = begin
  dirname(file) |> check_dir
  CSV.write(file, df; append=append, kw...)
end
