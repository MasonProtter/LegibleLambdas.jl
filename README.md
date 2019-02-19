<!-- LegibleLambdas -->

<!-- [[file:~/Documents/Julia/scrap.org::*LegibleLambdas][LegibleLambdas:1]] -->

[![Build Status](https://travis-ci.com/MasonProtter/LegibleLambdas.jl.svg?branch=master)](https://travis-ci.com/MasonProtter/LegibleLambdas.jl)

Tired of anonymous functions looking like this?
```julia
julia> f = x -> x + 1
#1 (generic function with 1 method)
```
Enter LegibleLambas
```julia
julia> using LegibleLambdas

julia> g = @λ(x -> 2x)
(x->2x)

julia> h = @λ(x -> g(x)/3)
(x->g(x) / 3)

julia> h(3)
2.0
```

If you use it in julia **v1.1+**, it will be more legible

```julia
julia> D(f, ϵ=1e-10) = @λ(x -> (f(x+ϵ)-f(x))/ϵ)
D (generic function with 2 methods)

julia> D(sin)
(x->(sin(x + 1e-10) - sin(x)) / 1e-10)
```
