using DataStructures

include("./download.jl")

input = getinput(2021, 5)

sample = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""

function parseinput(input)
    substrings = map(line -> match(r"(\d+),(\d+) -> (\d+),(\d+)", line).captures, split(strip(input), "\n"))
    map(line -> map(value -> parse(Int, value), line), substrings)
end

function between(a, b)
    if a > b
        b:a
    else
        a:b
    end
end

function part1(input)
    values = parseinput(input)

    world = DefaultDict(0)

    for value in values
        if value[1] == value[3]
            for x in between(value[2], value[4])
                world[(value[1], x)] += 1
            end
        elseif value[2] == value[4]
            for y in between(value[1], value[3])
                world[(y, value[2])] += 1
            end
        end
    end

    count(pair -> pair[2] > 1, world)
end

@assert part1(sample) == 5
@time part1(input)
@show part1(input)

struct DiagonalIterator
    x
    y
end

function Base.iterate(iter::DiagonalIterator)
    stepx = iterate(iter.x)
    stepy = iterate(iter.y)
    if stepx == nothing || stepy == nothing
        nothing
    else
        (stepx[1], stepy[1]), (stepx[2], stepy[2])
    end
end

function Base.iterate(iter::DiagonalIterator, state)
    stepx = iterate(iter.x, state[1])
    stepy = iterate(iter.y, state[2])
    if stepx == nothing || stepy == nothing
        nothing
    else
        (stepx[1], stepy[1]), (stepx[2], stepy[2])
    end
end

function between2(a1, a2, b1, b2)
    first = if a1 > b1
        a1:-1:b1
    else
        a1:b1
    end
    second = if a2 > b2
        a2:-1:b2
    else
        a2:b2
    end

    DiagonalIterator(first, second)
end

function pprint(world)
    dimension = maximum(pair -> maximum(pair[1]), world)
    for x in 0:dimension
        for y in 0:dimension
            if world[(x, y)] == 0
                print(". ")
            else
                print("$(world[(x, y)]) ")
            end
        end
        println()
    end
end

function part2(input)
    values = parseinput(input)

    world = DefaultDict(0)

    for value in values
        if value[1] == value[3]
            for x in between(value[2], value[4])
                world[(x, value[1])] += 1
            end
        elseif value[2] == value[4]
            for y in between(value[1], value[3])
                world[(value[2], y)] += 1
            end
        else
            for (x, y) in between2(value[1], value[2], value[3], value[4])
                world[(y, x)] += 1
            end
        end
    end

    # pprint(world)

    count(pair -> pair[2] > 1, world)
end

@assert part2(sample) == 12
@assert part2(input) > 19098
@time part2(input)
@show part2(input)
