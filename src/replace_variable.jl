using MLStyle: @match


replace_variable(ex::Expr, list::Dict) = replace_variable(Val(ex.head), ex, list)
replace_variable(ex::LineNumberNode, list::Dict) = ex
replace_variable(::Val, ex, list) = copy(ex) # skip other patterns

function replace_variable(::Val{:->}, ex::Expr, list::Dict)
    Expr(:->, ex.args[1], replace_variable(ex.args[2], list))
end

function replace_variable(::Val{:block}, ex::Expr, list::Dict)
    out = Expr(:block)
    for each in ex.args
        push!(out.args, replace_variable(each, list))
    end
    return out
end

function replace_variable(ex::Symbol, list::Dict)
    ex in keys(list) && return list[ex]
    return ex
end

function replace_variable(::Val{:kw}, ex::Expr, list::Dict)
    if ex.args[1] in keys(list)
        return Expr(:kw, ex.args[1], list[ex.args[1]])
    else
        return ex
    end
end

function replace_variable(::Val{:parameters}, ex::Expr, list::Dict)
    out = Expr(:parameters)
    for each in ex.args
        push!(out.args, replace_variable(each, list))
    end
    return out
end

function replace_variable(::Val{:call}, ex::Expr, list::Dict)
    out_ex = Expr(:call)
    for (k, each) in enumerate(ex.args)
        # expand ...
        e = @match each begin
            Expr(:..., x) =>
                if x in keys(list)
                    val = list[x]
                    append!(out_ex.args, val)
                else
                    push!(out_ex.args, each)
                end

            Expr(:parameters, xs...) => push!(out_ex.args, replace_variable(Val(:parameters), each, list))
            _ => push!(out_ex.args, replace_variable(each, list))
        end
    end

    return out_ex
end

replace_variable(x::Any, ::Dict) = x 
