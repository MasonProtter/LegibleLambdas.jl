macro λ(ex)
    return parse_lambda(ex)
end

"""
    parse_lambda(ex)

Parse a lambda expression to `LegibleLambda` constructor expression.
"""
function parse_lambda(ex::Expr)
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

struct LegibleLambda{F <: Function, T} <: Function
    λ::F
    ex::Expr
    vars::Dict{Symbol, T}
end

(f::LegibleLambda)(args...; kwargs...) = (f.λ)(args...; kwargs...)

function to_string(f::LegibleLambda)
    ex = replace_variable(f.ex, f.vars)

    ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
    return replace((repr(ex_cut |> pretty_kwargs)[2:end]), "->" => " -> ")
end

function Base.show(io::IO, f::LegibleLambda)
    print(io, to_string(f))
end

function Base.show(io::IO, ::MIME"text/plain", f::LegibleLambda)
    print(io, to_string(f))
end
