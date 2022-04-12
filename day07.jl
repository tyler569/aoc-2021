include("./download.jl")

input = getinput(2021, 7)

sample = """
16,1,2,0,4,2,7,1,2,14
"""

function parseinput(input)
    map(v -> parse(Int, v), split(strip(input), ","))
end

function part1(input)
    subs = parseinput(input)

    # for position in minimum(subs):maximum(subs)
    #     fuelusage = map(sub -> abs(position - sub), subs)
    #     @show (position, sum(fuelusage), fuelusage)
    # end

    minimum(sum(map(sub -> abs(position - sub), subs)) for position in minimum(subs):maximum(subs))
end

@assert part1(sample) == 37
@assert part1(input) > 389
@time @show part1(input)

function fuelusage(from, to)
    sum(0:(abs(from-to)))
end

function part2(input)
    subs = parseinput(input)

    minimum(sum(map(sub -> fuelusage(position, sub), subs)) for position in minimum(subs):maximum(subs))
end

@assert part2(sample) == 168
@time @show part2(input)
