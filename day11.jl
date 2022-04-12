include("./download.jl")

input = getinput(2021, 11)

sample = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""

function parseinput(input)
    arrays = split.(split(strip(input), "\n"), "")
    matrix = reduce(vcat, permutedims.(arrays))
    map(x -> parse(Int, x), matrix)
end

function adjascent(matrix, coordinate)
    coords = map(x -> coordinate + x, CartesianIndex(-1, -1):CartesianIndex(1, 1))
    map(c -> in(c, coords), CartesianIndices(matrix))
end

function coordsof(bmatrix)
    filter(c -> bmatrix[c], CartesianIndices(bmatrix))
end

function step(matrix)
    flashes = zeros(Bool, size(matrix))
    matrix .+= 1
    nines = matrix .> 9
    while count(nines) > 0
        addones = map(c -> adjascent(matrix, c), coordsof(nines))
        add = reduce(.+, addones)
        flashes .|= nines
        matrix .+= add
        nines = (matrix .> 9) .& .!flashes
    end
    numflashes = count(flashes)
    matrix .*= .!flashes
    numflashes
end

function part1(input)
    matrix = parseinput(input)
    sum(step(matrix) for _ in 1:100)
end

@assert part1(sample) == 1656
@time @show part1(input)

function part2(input)
    matrix = parseinput(input)
    s = 1
    while step(matrix) != length(matrix)
        s += 1
    end
    s
end

@assert part2(sample) == 195
@time @show part2(input)
