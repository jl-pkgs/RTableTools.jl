# Collection of R `data.table` functions in Julia

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jl-pkgs.github.io/RTableTools.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jl-pkgs.github.io/RTableTools.jl/dev)
[![CI](https://github.com/jl-pkgs/RTableTools.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/jl-pkgs/RTableTools.jl/actions/workflows/CI.yml)
[![Codecov](https://codecov.io/gh/jl-pkgs/RTableTools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jl-pkgs/RTableTools.jl)

> Dongdong Kong

`RTableTools.jl` implements the function of `merge`, `cbind`, `auto_read`, `auto_write`,
`expand_grid`, and other frequent used functions in R package [`data.table`](https://github.com/Rdatatable/data.table).

`auto_read` and `auto_write` support two formats: CSV (`.csv`) and Arrow (`.arrow`). The file extension determines the format.

## Installation

```
using Pkg
Pkg.add(url="https://github.com/jl-pkgs/RTableTools.jl")
```
