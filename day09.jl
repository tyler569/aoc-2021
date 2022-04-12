using StatsBase

include("./download.jl")

input = getinput(2021, 9)

sample = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

function parseinput(input)
    map.(vs -> parse.(Int, vs), split.(split(strip(input), "\n"), ""))
end

function part1(input)
    values = parseinput(input)
    matrix = reduce(vcat, permutedims.(values))

    out = zeros(size(matrix))
    result = 0

    for i in CartesianIndices(matrix)
        x, y = i.I
        value = matrix[x, y]

        if value < get(matrix, (x, y+1), Inf) &&
            value < get(matrix, (x, y-1), Inf) &&
            value < get(matrix, (x+1, y), Inf) &&
            value < get(matrix, (x-1, y), Inf)

            result += value + 1
        end
    end

    result
end

@assert part1(sample) == 15
@time @show part1(input)

function floodfill(matrix, position, region)
    if !in(position, CartesianIndices(matrix))
        return
    end

    if matrix[position] != 0
        return
    end

    matrix[position] = region
    x, y = position.I

    floodfill(matrix, CartesianIndex(x+1, y), region)
    floodfill(matrix, CartesianIndex(x-1, y), region)
    floodfill(matrix, CartesianIndex(x, y+1), region)
    floodfill(matrix, CartesianIndex(x, y-1), region)
end

function part2(input)
    values = parseinput(input)
    matrix = reduce(vcat, permutedims.(values))

    walls = (matrix .== 9)
    matrix .*= walls
    matrix .*= 1000

    # walls are region 9000
    
    region = 1
    
    for i in CartesianIndices(matrix)
        value = matrix[i]

        if value != 0
            continue
        end

        floodfill(matrix, i, region)
        region += 1
    end

    pairs = filter(p -> p.first != 9000, collect(countmap(vec(matrix))))
    pairs = sort(pairs, by=pair -> pair.second, rev=true)
    sizes = map(p -> p[2], pairs)
    prod(sizes[1:3])
end

@assert part2(sample) == 1134
@time @show part2(input)
