using DataStructures

include("./download.jl")

input = getinput(2021, 15)

sample = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""

function parseinput(input)
    rows = strip.(split(strip(input), "\n"))
    slots = split.(rows, "")
    slots = map(x -> parse.(Int, x), slots)
    matrix = reduce(vcat, permutedims.(slots))
end

function neighbors(matrix, coordinate)
    coords = map(x -> coordinate + x, CartesianIndex(-1, -1):CartesianIndex(1, 1))
    filter(c -> in(c, coords), CartesianIndices(matrix))
end

function straightneighbors(matrix, coordinate)
    directions = [CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1)]
    coords = map(x -> coordinate + x, directions)
    filter(c -> in(c, coords), CartesianIndices(matrix))
end

function pathfind(matrix)
    frontier = PriorityQueue{CartesianIndex, Int}()
    enqueue!(frontier, CartesianIndex(1, 1) => 0)
    camefrom = Dict()
    costsofar = Dict()
    camefrom[CartesianIndex(1, 1)] = 0
    costsofar[CartesianIndex(1, 1)] = 0

    while length(frontier) > 0
        current = dequeue!(frontier)
        if current == size(matrix)
            break
        end

        for next in straightneighbors(matrix, current)
            newcost = costsofar[current] + matrix[next]
            if !haskey(camefrom, next) || newcost < costsofar[next]
                costsofar[next] = newcost
                priority = newcost
                if haskey(frontier, next)
                    frontier[next] = minimum([frontier[next], priority])
                else
                    enqueue!(frontier, next, priority)
                end
                camefrom[next] = current
            end
        end
    end

    # for x in 1:size(matrix)[1]
    #     for y in 1:size(matrix)[2]
    #         print("$(lpad(costsofar[CartesianIndex(x, y)], 3, " ")) ")
    #     end
    #     println()
    # end

    costsofar[CartesianIndex(size(matrix))]
end

function part1(input)
    matrix = parseinput(input)

    pathfind(matrix)
end

@assert part1(sample) == 40
@time @show part1(input)

function wrap(n)
    if n > 9
        n - 9
    else
        n
    end
end

function expandboard(matrix)
    m = foldl(vcat, [foldl(hcat, [matrix .+ i for i in 0:4]) .+ j for j in 0:4])
    map(wrap, m)
end

function part2(input)
    matrix = expandboard(parseinput(input))

    pathfind(matrix)
end


@assert part2(sample) == 315
@time @show part2(input)
