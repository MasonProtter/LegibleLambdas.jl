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
:(@λ)

# NOTE: Base.@locals is in v1.1
@static if VERSION < v"1.1.0"
    macro λ(ex)
        if ex.head == :(->)
            ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
            name = (repr(ex_cut)[2:end])
            :(LegibleLambda($name, $(esc(ex))))
        else
            throw("Must be called on a Lambda expression")
        end
    end

    struct LegibleLambda{F <: Function} <: Function
        name::String
        λ::F
    end

    (f::LegibleLambda)(args...) = (f.λ)(args...)

    function Base.show(io::IO, f::LegibleLambda)
        print(io, f.name)
    end

    function Base.show(io::IO, ::MIME"text/plain", f::LegibleLambda)
        print(io, f.name)
    end

else

    macro λ(ex)
        if ex.head == :(->)
            ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
            name = (repr(ex_cut)[2:end])
            return quote
                LegibleLambda($(esc(ex)), $(QuoteNode(ex)), Base.@locals)
            end
        else
            throw("Must be called on a Lambda expression")
        end
    end

    struct LegibleLambda{F, T}
        λ::F
        ex::Expr
        vars::Dict{Symbol, T}
    end

    (f::LegibleLambda)(args...; kwargs...) = (f.λ)(args...; kwargs...)

    function to_string(f::LegibleLambda)
        ex = f.ex
        for (s, v) in f.vars
            ex = postwalk(x->x === s ? v : x, ex)
        end

        ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
        return (repr(ex_cut)[2:end])
    end

    function Base.show(io::IO, f::LegibleLambda)
        print(io, to_string(f))
    end

    function Base.show(io::IO, ::MIME"text/plain", f::LegibleLambda)
        print(io, to_string(f))
    end

end

macro lambda(ex)
    return :(@λ($ex))
end

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

end
