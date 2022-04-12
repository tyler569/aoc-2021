using DataStructures

include("./download.jl")

input = getinput(2021, 21)

sample = """
Player 1 starting position: 4
Player 2 starting position: 8
"""

function parseinput(input)
    parse.(Int, map(v -> v[1], match.(r"Player . starting position: (\d)", split(strip(input), "\n"))))
end

function simulate(p1, p2)
    p1 -= 1
    p2 -= 1
    s1, s2 = 0, 0
    d = Iterators.cycle(1:100)
    dstate = 0
    dcount = 0
    function roll()
        dcount += 1
        result, dstate = iterate(d, dstate)
        result
    end
    while s1 < 1000 && s2 < 1000
        p1 += roll() + roll() + roll()
        p1 %= 10
        s1 += p1 + 1
        if s1 >= 1000
            break
        end
        p2 += roll() + roll() + roll()
        p2 %= 10
        s2 += p2 + 1
    end
    s1, s2, dcount
end

function part1(input)
    p1, p2 = parseinput(input)
    s1, s2, dcount = simulate(p1, p2)
    minimum([s1, s2]) * dcount
end

@assert part1(sample) == 739785
@time @show part1(input)

function playeroutcomes(start, points = 0, round = 0)
    if points >= 21
        return Dict(round => 1)
    end
    out = DefaultDict(0)
    for r1 in 1:3, r2 in 1:3, r3 in 1:3
        roll = r1 + r2 + r3
        d = (start + roll) % 10
        outcomes = playeroutcomes(d, points + d + 1, round + 1)
        for (round, count) in outcomes
            out[round] += count
        end
    end
    out
end

function rounduniverses(outcomes, otheroutcomes, player, round)
    pf = player == 1
    otherexp = round - pf
    minround = minimum(keys(outcomes))
    mindiff = round - minround
    minus = sum(Int[otheroutcomes[round - n] * 27^(n-pf) for n in pf:mindiff])

    outcomes[round] * (27^otherexp - minus)
end

function universes(outcomes, otheroutcomes, player)
    sum(rounduniverses(outcomes, otheroutcomes, player, round) for round in keys(outcomes))
end

function part2(input)
    p1, p2 = parseinput(input)
    o1 = playeroutcomes(p1-1)
    o2 = playeroutcomes(p2-1)
    maximum([universes(o1, o2, 1), universes(o2, o1, 2)])
end

@assert part2(sample) == 444356092776315
@time @show part2(input)
