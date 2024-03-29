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

is_wsl() = Sys.islinux() && isfile("/mnt/c/Windows/System32/cmd.exe")
is_windows() = Sys.iswindows()
is_linux() = Sys.islinux()

"""
    path_mnt(path = ".")

Relative path will kept the original format.
"""
function path_mnt(path=".")
  # path = realpath(path)
  n = length(path)
  if is_wsl() && n >= 2 && path[2] == ':'
    pan = "/mnt/$(lowercase(path[1]))"
    path = n >= 3 ? "$pan$(path[3:end])" : pan
  elseif is_windows() && n >= 6 && path[1:5] == "/mnt/"
    pan = "$(uppercase(path[6])):"
    path = n >= 7 ? "$pan$(path[7:end])" : pan
  end
  path
end


"""
    fread(file::AbstractString; header=true, kw...)  

# Arguments
- `file`: the csv file to read
- `header`: whether the csv file has header?
- `kw`: other parameters for `CSV.File`

# Examaple
```
fread("a.csv")
```
"""
fread(file::AbstractString; header=true, kw...) = DataFrame(CSV.File(file; header, kw...))


"""
    fwrite(df, file; kw...)

```julia
df = DataFrame(A=1:3, B=4:6, C=7:9)
fwrite(df, "a.csv")
fwrite(df, "a.csv", append=true)
```
"""
fwrite(df::AbstractDataFrame, file::AbstractString; append=false, kw...) = begin
  dirname(file) |> check_dir
  CSV.write(path_mnt(file), df; append=append, kw...)
end
