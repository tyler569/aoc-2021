using Combinatorics
include("./download.jl")

input = getinput(2018, 1)

sample = """
+1
+1
-2
"""

function parseinput(input)
    map(x -> parse(Int, x), split(input))
end

function day1(input)
    values = parseinput(input)
    sum(values)
end

@assert day1(sample) == 0
@show day1(input)

function day2(input)
    values = parseinput(input)
    path = Dict()
    cur = 0

    while true
        for value in values
            if haskey(path, cur)
                return cur
            end
            path[cur] = 1
            cur += value
        end
    end
end

@assert day2(sample) == 0
@show day2(input)
@time day2(input)
