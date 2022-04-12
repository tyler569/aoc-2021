include("./download.jl")

input = getinput(2021, 1)

sample = """
199
200
208
210
200
207
240
269
260
263
"""

function parseinput(input)
    map(x->parse(Int, x), split(input))
end

function mpairs(vec)
    l = vec[1]
    out = []
    for a in vec[2:end]
        push!(out, (l, a))
        l = a
    end
    out
end

function part1(input)
    values = parseinput(input)
    pairs = mpairs(values)
    count(map(pair -> pair[2] > pair[1], pairs))
end

@assert part1(sample) == 7
@show part1(input)

function windows(vec, windowlen)
    windowlen -= 1
    n = 0
    out = []
    for a in 1:length(vec)-windowlen
        push!(out, vec[a:a+windowlen])
    end
    out
end

function part2(input)
    values = parseinput(input)
    w = windows(values, 3)
    x = map(sum, w)
    pairs = mpairs(x)
    count(map(pair -> pair[2] > pair[1], pairs))
end

@assert part2(sample) == 5
@show part2(input)
