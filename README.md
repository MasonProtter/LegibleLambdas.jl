# LegibleLambdas

[![Build Status](https://travis-ci.com/MasonProtter/LegibleLambdas.jl.svg?branch=master)](https://travis-ci.com/MasonProtter/LegibleLambdas.jl)

Legible Lambdas for Julia.

## Installation

In julia **v1.0+**, type `]` to enter package mode, and:

```
pkg> add LegibleLambdas
```

## Introduction

LegibleLambdas.jl provides a macro `@λ` (and an alias `@lambda`) for
defining a type of anonymous function which is printed in a nicer form
than the relatively uninformative gensyms of traditional anonymous
functions.

Compare the printing of 
```julia
julia> f = x -> x + 1
#1 (generic function with 1 method)
```
with 
```julia
julia> using LegibleLambdas

julia> g = @λ(x -> x + 1)
(x -> x + 1)
```

## License

MIT License
