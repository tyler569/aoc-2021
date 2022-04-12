include("./download.jl")

input = getinput(2021, 6)

sample = """
3,4,3,1,2
"""

function parseinput(input)
    map(v -> parse(Int, v), split(strip(input), ","))
end

function part1(input, days)
    school = parseinput(input)

    function step(state)
        newstate = []
        for fish in state
            if fish > 0
                push!(newstate, fish-1)
            else
                push!(newstate, 6) # old fish
                push!(newstate, 8) # new fish
            end
        end
        newstate
    end

    for i in 1:days
        school = step(school)
    end

    length(school)
end

@assert part1(sample, 18) == 26
@assert part1(sample, 80) == 5934
@time @show part1(input, 80)

function part2(input, days)
    school = zeros(BigInt, 9)
    for fish in parseinput(input)
        school[fish+1] += 1
    end

    for day in 1:days
        spawning = school[1]
        school[1:8] = school[2:9]
        school[7] += spawning
        school[9] = spawning
    end

    sum(school)
end

@assert part2(sample, 18) == 26
@assert part2(sample, 80) == 5934
@assert part2(sample, 256) == 26984457539
@time @show part2(input, 256)
