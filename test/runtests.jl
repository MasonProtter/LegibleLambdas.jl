using Test, LegibleLambdas

@testset "Basics" begin
    f = @λ(x -> x + 1)
    @test f isa Function
    @test repr(f) == "(x -> x + 1)"
    @test f(2) == 3

    g = @λ((x,y) -> x^2 + y^2)
    @test g isa Function
    @test repr(g) == "((x, y) -> x ^ 2 + y ^ 2)"
    @test g(-15.0, 10.0) == 325.0

    h = @λ((x, y, z) -> occursin(x, y*z))
    @test h isa Function
    @test repr(h) == "((x, y, z) -> occursin(x, y * z))"
    @test h("hi", "abh", "ing")
end

@testset "Closures" begin
    D(f, ϵ=1e-10) = @λ(x -> (f(x+ϵ)-f(x))/ϵ)

    @test repr(D(sin)) == "(x -> ((sin)(x + 1.0e-10) - (sin)(x)) / 1.0e-10)"

    @test D(sin)(π) == -1.000000082740371
end

@testset "Unicode" begin
    @test repr(@λ((η) -> η^2 + 1)) == "(η -> η ^ 2 + 1)"
end

@testset "Varargs" begin
    f = @λ((x=1) -> x^2 + 1)
    @test repr(f) == "(x = 1 -> x ^ 2 + 1)"

    g = @λ((x, y=1) -> x^2 + y)
    @test repr(g) == "((x, y = 1) -> x ^ 2 + y)"

    h = @λ((x, y=1, z=2) -> x^2 + y/z)
    @test repr(h) == "((x, y = 1, z = 2) -> x ^ 2 + y / z)"
end
