using Combinatorics

include("./download.jl")

input = getinput(2021, 18)

sample1 = """
[1,1]
[2,2]
[3,3]
[4,4]
"""

sample2 = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
"""

sample3 = """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
"""

sample4 = """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
"""

sample5 = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""

function parsenumber(line)
    chars = split(filter(c -> c != ',', line), "")
    mapping = Dict{Char, Any}('0':'9' .=> 0:9)
    mapping['['] = :<
    mapping[']'] = :>
    map(c -> mapping[c[1]], chars)
end

function pair(line, start=1)
    depth = 0
    if line[start] != :<
        return line[start:start]
    end
    for i in start:length(line)
        if line[i] == :<
            depth += 1
        elseif line[i] == :>
            depth -= 1
        end
        if depth == 0
            return line[start:i]
        end
    end
    @assert "Malformed number" && false
end

# @show pair([:<, 1, 2, :>])
# @show pair([:<, :<, 1, 2, :>, 2, :>], 3)
# @show pair([:<, :<, 1, 2, :>, 2, :>], 2)
# @show pair([:<, :<, 1, 2, :>, 2, :>], 1)

function nth(line, index, base=1)
    if line[base] != :<
        @assert "Not a pair" && false
    end
    if index == 1
        pair(line, base+1)
    else
        pair(line, base+1+length(pair(line, base+1)))
    end
end

function replace!(collection, index, elements)
    out = popat!(collection, index)
    while length(elements) > 0
        insert!(collection, index, pop!(elements))
    end
    out
end

# v = [:<, 1, 2, :>]
# 
# @show replace!(v, 3, [:<, 3, 4, :>])
# @show v

function replacepair!(collection, pairindex, elements)
    out = pair(collection, pairindex)
    for i in 1:length(out)
        popat!(collection, pairindex)
    end
    while length(elements) > 0
        insert!(collection, pairindex, pop!(elements))
    end
    out
end

# @show replacepair!(v, 3, [0])
# @show v

function depth5(pair)
    depth = 0
    for i in 1:length(pair)
        elem = pair[i]
        if elem == :<
            depth += 1
        elseif elem == :>
            depth -= 1
        end
        if depth > 4
            return i
        end
    end
end

# v = "[[[[[9,8],1],2],3],4]"
# n = parsenumber(v)
# 
# @show depth5(n)
# @show pair(n, depth5(n))

function previousraw(pair, index)
    for i in index-1:-1:1
        if pair[i] != :< && pair[i] != :>
            return i
        end
    end
    nothing
end

function nextraw(pair, index)
    for i in index+1:length(pair)
        if pair[i] != :< && pair[i] != :>
            return i
        end
    end
    nothing
end

function explode!(pair)
    toblow = depth5(pair)
    if toblow == nothing
        return false
    end

    # Exploding pairs will always consist of two regular numbers
    first = pair[toblow + 1]
    second = pair[toblow + 2]

    replacepair!(pair, toblow, [0])

    previndex = previousraw(pair, toblow)
    nextindex = nextraw(pair, toblow)

    if previndex != nothing
        pair[previndex] += first
    end
    if nextindex != nothing
        pair[nextindex] += second
    end
    true
end

updiv2(a) = div((a + 1) & ~1, 2)

function split!(pair)
    for i in 1:length(pair)
        if pair[i] == :> || pair[i] == :<
            continue
        elseif pair[i] > 9
            replace!(pair, i, [:<, div(pair[i], 2), updiv2(pair[i]), :>])
            return true
        end
    end
    false
end

function normalize!(pair)
    while explode!(pair) || split!(pair)
    end
end

function normalize(pair)
    p = copy(pair)
    normalize!(p)
    p
end

function addpair(p1, p2)
    normalize([:<, p1..., p2..., :>])
end

function parseinput(input)
    map(parsenumber, split(input, "\n"))
end

function magnitude(pair)
    if length(pair) == 1
        return pair[1]
    end
    magnitude(nth(pair, 1)) * 3 +  magnitude(nth(pair, 2)) * 2
end

@assert magnitude([9]) == 9
@assert magnitude([:<, 1, 9, :>]) == 21
@assert magnitude([:<, 9, 1, :>]) == 29

function part1(input)
    result = reduce(addpair, parseinput(strip(input)))
    magnitude(result)
end

@assert part1(sample1) == 445
@assert part1(sample2) == 791
@assert part1(sample3) == 1137
@assert part1(sample4) == 3488
@time @show part1(input)

function part2(input)
    lines = parseinput(strip(input))
    maximum(p -> magnitude(addpair(p...)), permutations(lines, 2))
end

@assert part2(sample5) == 3993
@time @show part2(input)
