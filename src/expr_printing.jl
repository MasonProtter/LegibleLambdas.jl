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
