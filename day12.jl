using StatsBase

include("./download.jl")

input = getinput(2021, 12)

sample1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

sample2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

sample3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

function parseinput(input)
    lines = split(strip(input), "\n")
    matches = map(l -> match(r"(\w+)-(\w+)", l), lines)
    map(m -> (m[1], m[2]), matches)
end

function largecave(cave)
    in(cave[1], 'A':'Z')
end

function cavesystem(pairs)
    caves = Dict()
    for (a, b) in pairs
        if haskey(caves, a) && !in(caves[a], b)
            push!(caves[a], b)
        else
            caves[a] = [b]
        end

        if haskey(caves, b) && !in(caves[b], a)
            push!(caves[b], a)
        else
            caves[b] = [a]
        end
    end
    caves
end

function validpath(path)
    smallcaves = filter(c -> !largecave(c), path)
    length(smallcaves) == length(unique(smallcaves))
end

function findpaths(caves; prefix=["start"], validtest=validpath)
    if prefix[end] == "end"
        return [prefix]
    end
    steps = caves[prefix[end]]
    possiblepaths = map(step -> push!(copy(prefix), step), steps)
    legalpaths = filter!(validtest, possiblepaths)
    collect(Iterators.flatten(map(path -> findpaths(caves; prefix=path, validtest=validtest), legalpaths)))
end

function part1(input)
    pairs = parseinput(input)
    caves = cavesystem(pairs)
    paths = findpaths(caves)
    length(paths)
end

@assert part1(sample1) == 10
@assert part1(sample2) == 19
@assert part1(sample3) == 226
@time @show part1(input)

function validpath2(path)
    counts = countmap(path)
    smallcaves = unique(filter(c -> !largecave(c), path))

    if haskey(counts, "start") && counts["start"] > 1
        return false
    end

    if haskey(counts, "end") && counts["end"] > 1
        return false
    end
   
    count(counts[cave] == 2 for cave in smallcaves) <= 1 &&
        all(counts[cave] < 3 for cave in smallcaves)
end

function part2(input)
    pairs = parseinput(input)
    caves = cavesystem(pairs)
    paths = findpaths(caves; validtest=validpath2)
    length(paths)
end

@assert part2(sample1) == 36
@assert part2(sample2) == 103
@assert part2(sample3) == 3509
@time @show part2(input)
