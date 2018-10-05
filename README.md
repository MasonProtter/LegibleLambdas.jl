<!-- LegibleLambdas -->

<!-- [[file:~/Documents/Julia/scrap.org::*LegibleLambdas][LegibleLambdas:1]] -->
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
```

LegibleLambdas currently aren't as ideally legible as I'd like. For instance,
```julia
julia> D(f, ϵ=1e-10) = @λ(x -> (f(x+ϵ)-f(x))/ϵ)
D (generic function with 2 methods)

julia> D(sin)
(x->(f(x + ϵ) - f(x)) / ϵ)
```
whereas in a perfect world the output of the last line would be
```julia
(x->(sin(x + 1e-10) - sin(x)) / 1e-10)
```
so if you know how to make the above work, I'd love to hear from you.
<!-- LegibleLambdas:1 ends here -->
