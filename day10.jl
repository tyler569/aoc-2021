using Statistics

include("./download.jl")

input = getinput(2021, 10)

test = "[()[]]"

sample = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

function parseinput(input)
    collect.(split(input))
end

openers = "([{<"
closers = ")]}>"

indexof(value, collection) = findall(value, collection)[1]
closerof(opener) = closers[indexof(opener, openers)]

function validate(line)
    if length(line) == 0
        return true
    end

    if in(line[1], closers)
        return true
    end

    e = popfirst!(line)
    v = validate(line)
    if v != true
        return v
    end

    if length(line) == 0
        return true
    end

    d = popfirst!(line)
    if closerof(e) != d
        return d
    end
    
    validate(line)
end

illegalvalues = Dict(true => 0, ')' => 3, ']' => 57, '}' => 1197, '>' => 25137)

function part1(input)
    lines = parseinput(input)
    sum(v -> illegalvalues[v], validate.(lines))
end

# @assert validate(parseinput(test)[1])
@assert part1(sample) == 26397
@time @show part1(input)

function complete(line, acc = [])
    if length(line) == 0
        return acc
    end

    if in(line[1], closers)
        return acc
    end

    c = popfirst!(line)
    complete(line, acc)
    if length(line) == 0
        push!(acc, closerof(c))
    elseif in(line[1], closers)
        popfirst!(line)
    end

    complete(line, acc)
end

test2 = "[()"
addedvalues = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)

function score(output)
    values = map(v -> addedvalues[v], output)
    values .*= (5 .^ collect(length(values)-1:-1:0))
    sum(values)
end

function part2(input)
    lines = parseinput(input)
    validlines = filter(line -> validate(copy(line)) == true, lines)
    completions = complete.(validlines)
    scores = score.(completions)
    Int(median(scores))
end

@assert part2(test2) == 2
@assert part2(sample) == 288957
@time @show part2(input)
