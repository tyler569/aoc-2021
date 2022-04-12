include("./download.jl")

input = getinput(2021, 8)

sample = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""

function parseinput(input)
    lines = split(strip(input), "\n")
    halves = [split(line, " | ") for line in lines]
end

function part1(input)
    parts = parseinput(input)
    outputs = [split(part[2]) for part in parts]

    count(output -> in(length(output), [2, 3, 4, 7]), Iterators.flatten(outputs))
end

@assert part1(sample) == 26
@time @show part1(input)

function decode(signals)
    counts = Dict('a' => 0, 'b' => 0, 'c' => 0, 'd' => 0, 'e' => 0, 'f' => 0, 'g' => 0)
    mappings = Dict()
    for c in filter(c -> in(c, 'a':'g'), signals)
        counts[c] += 1
    end

    @assert length(findall(v -> v == 4, counts)) == 1
    @assert length(findall(v -> v == 6, counts)) == 1
    @assert length(findall(v -> v == 7, counts)) == 2
    @assert length(findall(v -> v == 8, counts)) == 2
    @assert length(findall(v -> v == 9, counts)) == 1

    mappings['e'] = findall(v -> v == 4, counts)[1]
    mappings['b'] = findall(v -> v == 6, counts)[1]
    mappings['f'] = findall(v -> v == 9, counts)[1]

    possible_dg = findall(v -> v == 7, counts)
    possible_ac = findall(v -> v == 8, counts)

    numbers = split(signals)

    one = filter(x -> length(x) == 2, numbers)[1]
    four = filter(x -> length(x) == 4, numbers)[1]

    mappings['d'] = filter(s -> in(s, four), possible_dg)[1]
    mappings['g'] = filter(s -> !in(s, four), possible_dg)[1]

    mappings['c'] = filter(s -> in(s, one), possible_ac)[1]
    mappings['a'] = filter(s -> !in(s, one), possible_ac)[1]
    mappings[' '] = ' '

    Dict(values(mappings) .=> keys(mappings))
end

function convert(mapping, string)
    map(c -> mapping[c], string)
end

function numberize(signal)
    if issetequal(signal, "abcefg")
        0
    elseif issetequal(signal, "cf")
        1
    elseif issetequal(signal, "acdeg")
        2
    elseif issetequal(signal, "acdfg")
        3
    elseif issetequal(signal, "bcdf")
        4
    elseif issetequal(signal, "abdfg")
        5
    elseif issetequal(signal, "abdefg")
        6
    elseif issetequal(signal, "acf")
        7
    elseif issetequal(signal, "abcdefg")
        8
    elseif issetequal(signal, "abcdfg")
        9
    else
        println("Bad number! $signal")
    end
end

function part2_line(parts)
    signal, output = parts
    mapping = decode(signal)
    convertedsignal = convert(mapping, signal)
    convertedoutput = convert(mapping, output)
    value = map(numberize, split(convertedoutput))
    value = sum(value .* (10 .^ collect(3:-1:0)))
end

function part2(input)
    parts = parseinput(input)
    sum(map(part2_line, parts))
end

@assert part2(sample) == 61229
@time @show part2(input)
