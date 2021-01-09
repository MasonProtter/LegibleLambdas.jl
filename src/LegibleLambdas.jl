module LegibleLambdas

using MacroTools: postwalk
export @λ, @lambda, LegibleLambda

"""
    @λ <lambda definition>

Create legible lambdas.

# Example

```julia
julia> @λ(x -> g(x)/3)
(x -> g(x)/3)
```
"""
macro λ(ex)
    return parse_lambda(ex)
end

eval(:(const $(Symbol("@lambda")) = $(Symbol("@λ"))))

"""
    parse_lambda(ex)

Parse a lambda expression to `LegibleLambda` constructor expression.
"""
function parse_lambda(ex)
    if ex.head == :(->)
        :(LegibleLambda($(QuoteNode(ex)), $(esc(ex))))
    else
        throw("Must be called on a Lambda expression")
    end
end

#------------------------------------------------------------------------------------

struct LegibleLambda{F <: Function} <: Function
    ex::Expr
    λ::F
end

(f::LegibleLambda)(args...) = (f.λ)(args...)

function Base.show(io::IO, f::LegibleLambda)
    show(io, MIME"text/plain"(), f)
end

function Base.show(io::IO, ::MIME"text/plain", f::LegibleLambda)
    l_names = propertynames(f.λ)
    ex = f.ex
    foreach(l_names) do name
        ex = postwalk(ex) do s
            s === name ? getfield(f.λ, name) : s
        end
    end
    ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
    name = replace((repr(ex_cut |> pretty_kwargs)[2:end]), "->" => " -> ") 
    print(io, name)
end

#------------------------------------------------------------------------------------

cutlnn(x) = x
function cutlnn(ex::Expr)
    Expr(ex.head, ex.args[[!(arg isa LineNumberNode) for arg in ex.args]]...)
end

cutblock(x) = x
function cutblock(ex::Expr)
    if (ex.head == :block) && (length(ex.args)==1)
        ex.args[1]
    else
        ex
    end
end

tupleargs(x::Symbol) = (x,)
function tupleargs(ex::Expr)
    if ex.head == :tuple
        Tuple(ex.args)
    else
        throw("expression must have head `:tuple`")
    end
end

pretty_kwargs(x::Symbol) = x
function pretty_kwargs(ex)
    if ex.args[1] isa Expr
        if ex.args[1].head == :block
            exout = copy(ex)
            exout.args[1].head = :tuple
            exout
        else
            ex
        end
    else
        ex
    end
end


end
