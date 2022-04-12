using DataStructures
using Combinatorics
include("./download.jl")

input = getinput(2018, 2)

sample = """
abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab
"""

function parseinput(input)
    split(input)
end

function countletters(value)
    counts = DefaultDict(0)
    for letter in value
        counts[letter] += 1
    end
    twos = any((v == 2 for (k, v) in counts))
    threes = any((v == 3 for (k, v) in counts))
    (twos, threes)
end

rotate(aot) = ([a for (a, b) in aot], [b for (a, b) in aot])

function day1(input)
    values = parseinput(input)
    letters = map(countletters, values)
    (twos, threes) = rotate(letters)
    count(twos) * count(threes)
end

@assert day1(sample) == 12
@show day1(input)

compare(a, b) = broadcast(!=, split(a, ""), split(b, ""))

function day2(input)
    values = parseinput(input)
    @show map(((a, b)) -> compare(a, b), combinations(values, 2))
end

@assert day2(sample) == 0
@show day2(input)
