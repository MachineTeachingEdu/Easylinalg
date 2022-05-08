include(joinpath("..", "types", "zero", "zeroDefinitions.jl"))
include(joinpath("..", "types", "Signal", "SignalDefinitions.jl"))
include(joinpath("..", "types", "Point2D", "Point2DDefinitions.jl"))
include(joinpath("..", "types", "Point3D", "Point3DDefinitions.jl"))
include(joinpath("..", "types", "Arrow2D", "Arrow2DDefinitions.jl"))
include(joinpath("..", "types", "Arrow3D", "Arrow3DDefinitions.jl"))
include(joinpath("..", "types", "Image", "ImageDefinitions.jl"))

# É necessário acrescentar types conforme criam-se novos tipos
types = Union{Signal, Point2D, Point3D, Arrow2D, Arrow3D}
special_types = Union{Image}
numberTypes = Union{Integer, Float64}


function convex_combination(B,increment)
    x=1:-increment:0
    y=0:increment:1
    C=[x'; y']
    A = B * C
    return A
end

function *(S::Vector{<:types}, w::Vector{<:numberTypes})
    T = toNumberMatrix(S)
    T = T * w
    K = deepcopy(S[1])
    s = size(T)[1]
    for i=1:s
        setindex!(K, T[i], i)
    end
    return K
end


function *( S::Vector{<:types}, w::Matrix{<:numberTypes})
    element = deepcopy(S[1])
    type = typeof(element) 
    K = Vector{type}([element])
    T = toNumberMatrix(S)
    T = T * w
    s = size(T)[2]
    for i=1:s
        for j=1:size(T)[1]
            K[i][j] = T[j,i]
        end
        if( i < s)
            push!(K, deepcopy(element))
        end
    end
    return K
end

function *( S::types, w::Matrix{<:numberTypes})
    T = toNumberVector(S)'
    T = T * w
    R = deepcopy(S)
    for i=1:size(T)[2]
        R[i] = T[i]
    end
    return R
end


function *( S::Image, w::Matrix{<:numberTypes})
    img = ToNativeImage(S)
    s = permutedims(collect(size(img))) * w
    sf = Tuple(Int.(permutedims(abs.(s))))
    e = fill(RGB(0.0,0.0,0.0), sf)
    for i in CartesianIndices(img)
        newIndex = [i[1] i[2]] * w
        x = (newIndex[1] + sf[1]) % sf[1] + 1
        y = (newIndex[2] + sf[2]) % sf[2] + 1
        idx = CartesianIndex(Int(x), Int(y))
        e[idx] = img[i]
    end
    return Image(e)
end

function *( S::Vector{<:Image}, w::Matrix{<:numberTypes})
    T = ToNativeImage.(S)
    T = permutedims(hcat(T)) * w
    K = Image.(T)
    return vec(permutedims(K))
end

function *( S::Vector{<:Image}, w::Vector{<:numberTypes})
    T = ToNativeImage.(S)
    T = permutedims(hcat(T)) * w
    K = Image.(T)
    return vec(permutedims(K))
end





function toNumberMatrix(S::Vector{<:types})
    K = zeros(size(S[1])[1], size(S)[1])
    for i=1:size(S)[1]
        K[:,i] = toNumberVector(S[i])
    end
    return K
end

function toNumberVector(S::types)
    type = typeof(getindex(S, 1))
    K = Vector{type}()
    for j=1:size(S)[1]
        push!(K, getindex(S, j))
    end
    return K
end

function Base.:\(S::Vector{<:types}, W::Vector{<:types})
    K = toNumberMatrix(S)
    J = toNumberMatrix(W)    
    return K\J
end

