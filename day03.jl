using StatsBase

include("./download.jl")

input = getinput(2021, 3)

sample = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

function parseinput(input)
    split(strip(input))
end

function bitarraytoint(array)
    sum(array .* (2 .^ collect(length(array)-1:-1:0)))
end

function gammatoepsilon(gamma, length)
    (~gamma) & (2^length - 1)
end

function part1(input)
    values = parseinput(input)
    valuecount = length(values)
    valuelength = length(values[1])

    counts = []
    for bit in 1:valuelength
        push!(counts, 0)
        for value in values
            if value[bit] == '1'
                counts[end] += 1
            end
        end
    end
    bitarray = BitArray(map(x -> x >= valuecount / 2, counts))
    gamma = bitarraytoint(bitarray)
    epsilon = gammatoepsilon(gamma, length(bitarray))
    gamma * epsilon
end

@assert part1(sample) == 198
@show part1(input)

function findbit(same, different)
    function (d)
        m = countmap(d)
        if m['0'] == m['1']
            same
        else
            different(p -> p[2] => p[1], m).second
        end
    end
end

oxygenbit = findbit('1', maximum)
co2bit = findbit('0', minimum)

function filterfind(values, bitmethod)
    values = copy(values)
    for bit in 1:length(values[1])
        if length(values) == 1
            break
        end
        winner = bitmethod(map(v -> v[bit], values))
        values = filter(v -> v[bit] == winner, values)
    end
    @assert length(values) == 1
    values[1]
end

function tonumber(value)
    sum(parse.(Int, value) .* (2 .^ collect(length(value)-1:-1:0)))
end

function part2(input)
    values = collect.(strip.(split(input)))
    oxygenvalue = filterfind(values, oxygenbit)
    co2value = filterfind(values, co2bit)
    tonumber(oxygenvalue) * tonumber(co2value)
end

@assert part2(sample) == 230
@show part2(input)
