@testset verbose = true "Signal Testes" begin
    @testset "Build Ops" begin
        # test construction function
        @test SignalBuildU(cos, -10.0:0.1:10.0) == Signal(collect(-10.0:0.1:10.0), cos.(-10.0:0.1:10.0))
        @test SignalBuild([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) == Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0])
        # test type of concatenation
        @test typeof([SignalBuildU(sin, -10.0:0.1:10.0), SignalBuildU(x -> sin(4.0 * x), -10.0:0.1:10.0)]) == Vector{Signal}
    end;
    @testset "Base Ops" begin
        @test Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) + Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) == Signal([1.0, 2.0, 3.0], [2.0, 4.0, 6.0])
        @test Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) - Signal([1.0, 2.0, 3.0], [1.0, 1.0, 1.0]) == Signal([1.0, 2.0, 3.0], [0.0, 1.0, 2.0])
        @test Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) * 2 == Signal([1.0, 2.0, 3.0], [2.0, 4.0, 6.0])
        @test 2 * Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) == Signal([1.0, 2.0, 3.0], [2.0, 4.0, 6.0])
        @test Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) / 2 == Signal([1.0, 2.0, 3.0], [0.5, 1.0, 1.5])
        @test ( Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) * Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ) == 32
    end;
    @testset "Safe Checks" begin
        @test_throws ErrorException [Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([4.0, 5.0, 6.0], [4.0, 5.0, 6.0]) ]
        @test_throws ErrorException Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) + Signal([4.0, 5.0, 6.0], [4.0, 5.0, 6.0])
        @test_throws ErrorException Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]) - Signal([4.0, 5.0, 6.0], [4.0, 5.0, 6.0])
    end;
    @testset "EasyLinalg" begin
        @test convex_combination([Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ], 0.5) == [Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [2.5,  3.5,  4.5]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0])]
        @test toNumberVector(Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0])) == [1.0, 2.0, 3.0]
        @test toNumberMatrix([Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ]) == [1.0 4.0; 2.0 5.0; 3.0 6.0]
        @test ([ Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ]) * [ 2.0, 3.0] ==  Signal([1.0, 2.0, 3.0], [14.0, 19.0, 24.0])
        @test ([ Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ]) * [ 2.0 3.0; 4.0 5.0 ] == [ Signal([1.0, 2.0, 3.0], [18.0, 24.0, 30.0]), Signal([1.0, 2.0, 3.0], [23.0, 31.0, 39.0]) ]
        @test [Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0])] \ (([ Signal([1.0, 2.0, 3.0], [1.0, 2.0, 3.0]), Signal([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]) ]) * [ 2.0 3.0; 4.0 5.0 ]) ≈ [ 2.0 3.0; 4.0 5.0 ]
    end;
end;    
