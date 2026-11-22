import Arrow, CSV
export auto_read, auto_write, fread, fwrite


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

file_ext(file::AbstractString) = Val(Symbol(lowercase(splitext(file)[2])[2:end]))

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
    auto_read(file::AbstractString; header=true, kw...)  

# Arguments
- `file`: a CSV or Arrow file (identified by the `.arrow` extension)
- `header`: whether the CSV file has a header
- `kw`: other parameters for `CSV.File` or `Arrow.Table`

# Examaple
```
auto_read("a.csv")
```
"""
read_table(file, ::Val{:csv}; header=true, kw...) = CSV.File(file; header, kw...)
read_table(file, ::Val{:arrow}; header=true, kw...) = Arrow.Table(file; kw...)

auto_read(file::AbstractString; kw...) = DataFrame(read_table(file, file_ext(file); kw...))


"""
    auto_write(df, file; kw...)

Write CSV or Arrow according to the file extension. Arrow does not support `append=true` here.
Additional keywords are passed to `CSV.write` or `Arrow.write`.

```julia
df = DataFrame(A=1:3, B=4:6, C=7:9)
auto_write(df, "a.csv")
auto_write(df, "a.csv", append=true)
```
"""
write_table(df, file, ::Val{:csv}; append=false, kw...) = CSV.write(file, df; append, kw...)

function write_table(df, file, ::Val{:arrow}; append=false, kw...)
  append && throw(ArgumentError("append=true is not supported for Arrow files"))
  Arrow.write(file, df; kw...)
end

function auto_write(df::AbstractDataFrame, file::AbstractString; kw...)
  dirname(file) |> check_dir
  write_table(df, path_mnt(file), file_ext(file); kw...)
end

fread = auto_read
fwrite = auto_write
