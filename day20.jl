using DataStructures

include("./download.jl")

input = getinput(2021, 20)

sample = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..##
#..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###
.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#.
.#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#.....
.#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#..
...####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.....
..##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
"""

function parseinput(input)
    palette, image = split(strip(input), "\n\n")
    palette = replace(palette, "\n" => "")
    palette = map(c -> c == '#', collect(palette))
    image = split(image, "\n")

    dict = DefaultDict{Any, Bool}(false)
    for x in 1:length(image)
        for y in 1:length(image[1])
            dict[(x, y)] = image[x][y] == '#'
        end
    end

    palette, dict
end

function vforpoint(dict, (ax, ay))
    sum(vec([dict[(x, y)] for y = ay-1:ay+1, x = ax-1:ax+1]) .* (2 .^ collect(8:-1:0)))
end

function points(image)
    setdiff(keys(image), [:infinity])
end

function imagesize(image, buffer = 0)
    minx = minimum(e -> e[1], points(image)) - buffer
    maxx = maximum(e -> e[1], points(image)) + buffer
    miny = minimum(e -> e[2], points(image)) - buffer
    maxy = maximum(e -> e[2], points(image)) + buffer
    minx, miny, maxx, maxy
end

function enhance(dict, palette)
    if dict[:infinity]
        infinity = palette[512]
    else
        infinity = palette[1]
    end
    newdict = DefaultDict{Any, Bool}(infinity)
    minx, miny, maxx, maxy = imagesize(dict, 2)
    for x = minx:maxx, y = miny:maxy
        pointv = vforpoint(dict, (x, y))
        newv = palette[pointv+1]
        newdict[(x, y)] = newv
    end
    newdict
end

function pprint(image)
    minx, miny, maxx, maxy = imagesize(image, 1)
    for x = minx:maxx
        for y = miny:maxy
            if image[(x, y)]
                print("# ")
            else
                print(". ")
            end
        end
        println()
    end
end

function part1(input)
    palette, dict = parseinput(input)
    dict = enhance(dict, palette)
    dict = enhance(dict, palette)
    count(pair -> pair[2], dict)
end

@assert part1(sample) == 35
@assert part1(input) < 6897
@time @show part1(input)

function part2(input)
    palette, dict = parseinput(input)
    for i in 1:50
        dict = enhance(dict, palette)
    end
    count(pair -> pair[2], dict)
end

@assert part2(sample) == 3351
@time @show part2(input)
