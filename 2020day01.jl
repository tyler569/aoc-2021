using Combinatorics
include("./download.jl")

input = getinput(2020, 1)

sample = """
1721
979
366
299
675
1456
"""

function parseinput(input)
    map(x->parse(Int, x), split(input))
end

function part1(input)
    values = parseinput(input)
    pairs = collect(combinations(values, 2))
    pair = filter(x->sum(x) == 2020, pairs)[1]
    pair[1] * pair[2]
end

@assert part1(sample) == 514579
@show part1(input)

function part2(input)
    values = parseinput(input)
    pairs = collect(combinations(values, 3))
    pair = filter(x->sum(x) == 2020, pairs)[1]
    pair[1] * pair[2] * pair[3]
end

@assert part2(sample) == 241861950
@show part2(input)
