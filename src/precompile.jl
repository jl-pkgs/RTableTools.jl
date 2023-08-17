using PrecompileTools


# precompile(check_dir, (String,))
precompile(melt_list, (Vector{DataFrame},))

@setup_workload begin
  # str = " hello world! hello world! "
  # x = [1:10...]
  # w = rand(10)
  d1 = DataFrame(A=1:3, B=4:6, C=7:9)
  d2 = DataFrame(A=1:3, B=4:6, D=7:9)
  
  res = []
  map(i -> push!(res, d1), 1:4)

  # d = datatable(; x=1:4)
  @compile_workload begin
    df1 = melt_list(res, id=1:4)
    df2 = melt_list(res)

    d = dt_merge(d1, d2, by="A", suffixes=["_tas", ".rh"])
    
    # @show pwd()
    f = joinpath(@__DIR__, "../data/temp_gridInfo.csv")
    dat = fread(f)
    f = "$(tempdir())/tmp.csv"
    # f = tempname()
    fwrite(dat, f)
    rm(f)
    # fread(f)
  end
end
