using DataStructures
using IterTools
using StatsBase

include("./download.jl")

input = getinput(2021, 14)

sample = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""

function parseinput(input)
    polymer, rules = split(strip(input), "\n\n")
    mrules = map(line -> match(r"(\w+) -> (\w+)", line), split(rules, "\n"))
    prules = Dict(map(m -> ((m[1][1], m[1][2]) => m[2][1]), mrules))
    polymer, prules
end

function expand(polymer, rules)
    result = []
    pairs = partition(polymer, 2, 1)
    for pair in pairs
        rule = rules[pair]
        push!(result, pair[1])
        push!(result, rule)
    end
    push!(result, polymer[end])
    join(result)
end

function part1(input)
    polymer, rules = parseinput(input)
    for i in 1:10
        polymer = expand(polymer, rules)
    end
    counts = values(countmap(polymer))
    maximum(counts) - minimum(counts)
end

@assert part1(sample) == 1588
@time @show part1(input)

function optexpand(polymer, rules)
    newpolymer = DefaultDict(0)
    for (pair, count) in polymer
        letter = rules[pair]
        newpolymer[(pair[1], letter)] += count
        newpolymer[(letter, pair[2])] += count
    end
    newpolymer
end

function lettercount(optpolymer)
    letters = DefaultDict(0)
    for (pair, count) in optpolymer
        letters[pair[1]] += count
        letters[pair[2]] += count
    end
    # the first and last letter only appear once each
    for (letter, count) in letters
        if count % 2 != 0
            letters[letter] += 1
        end
    end
    map(v -> Int(v//2), values(letters))
end

function part2(input)
    polymer, rules = parseinput(input)
    optpolymer = countmap(partition(polymer, 2, 1))
    for i in 1:40
        optpolymer = optexpand(optpolymer, rules)
    end
    counts = lettercount(optpolymer)
    maximum(counts) - minimum(counts)
end

@assert part2(sample) == 2188189693529
@time @show part2(input)
