# For <: v1.1

macro λ(ex)
    return parse_lambda(ex)
end

"""
    parse_lambda(ex)

Parse a lambda expression to `LegibleLambda` constructor expression.
"""
function parse_lambda(ex)
    if ex.head == :(->)
        ex_cut = ex |> (ex -> postwalk(cutlnn, ex)) |> (ex -> postwalk(cutblock, ex))
        name = replace((repr(ex_cut |> pretty_kwargs)[2:end]), "->" => " -> ")
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
