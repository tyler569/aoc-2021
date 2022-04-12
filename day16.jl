include("./download.jl")

input = getinput(2021, 16)

test1 = "D2FE28"

sample1 = "8A004A801A8002F478"
sample2 = "620080001611562C8802118E34"
sample3 = "C0015000016115A2E0802F182340"
sample4 = "A0016C880162017C3686B18A3D4780"
sample5 = "EE00D40C823060"

function parseinput(input)
    input = strip(input)
    digits(Bool, parse(BigInt, input, base=16), base=2, pad=(length(input))*4)
end

popn!(collection, count) = [pop!(collection) for _ in 1:count]

function consume!(packet, bits)
    field = popn!(packet, bits)
    sum(field .* (2 .^ collect(bits-1:-1:0)))
end

function header!(packet)
    # version, type
    consume!(packet, 3), consume!(packet, 3)
end

function literal!(packet)
    going = true
    acc = BigInt(0)
    while going
        n = consume!(packet, 5)
        if n & (1 << 4) == 0
            going = false
        end
        acc <<= 4
        acc |= n & 0xF
    end
    (:literal, acc)
end

function lengthoperator!(packet, totallength)
    olength = length(packet)
    tolength = length(packet) - totallength
    subs = []
    while length(packet) > tolength
        push!(subs, parse!(packet))
    end
    if length(packet) != tolength
        println("Took too much!")
        @assert false
    end
    subs
end

function suboperator!(packet, subcount)
    subs = []
    for sub in 1:subcount
        push!(subs, parse!(packet))
    end
    subs
end

function operator!(type, packet)
    lengthtype = consume!(packet, 1)
    if lengthtype == 0
        totallength = consume!(packet, 15)
        subs = lengthoperator!(packet, totallength)
    elseif lengthtype == 1
        subcount = consume!(packet, 11)
        subs = suboperator!(packet, subcount)
    end
    (type, subs)
end

versions = Int[]

function parse!(packet)
    version, type = header!(packet)
    push!(versions, version)
    if type == 4
        literal!(packet)
    else
        operator!(type, packet)
    end
end

function part1(input)
    packet = parseinput(input)
    global versions = []
    parse!(packet)
    sum(versions)
end

# part1(test1)
@assert part1(sample1) == 16
@assert part1(sample2) == 12
@assert part1(sample3) == 23
@assert part1(sample4) == 31
@assert part1(sample5) == 14
@time @show part1(input)

function eval(tree)
    if tree[1] == :literal
        tree[2]
    elseif tree[1] == 0
        sum(map(eval, tree[2]))
    elseif tree[1] == 1
        prod(map(eval, tree[2]))
    elseif tree[1] == 2
        minimum(map(eval, tree[2]))
    elseif tree[1] == 3
        maximum(map(eval, tree[2]))
    elseif tree[1] == 5
        eval(tree[2][1]) > eval(tree[2][2])
    elseif tree[1] == 6
        eval(tree[2][1]) < eval(tree[2][2])
    elseif tree[1] == 7
        eval(tree[2][1]) == eval(tree[2][2])
    end
end

function part2(input)
    packet = parseinput(input)
    tree = parse!(packet)
    eval(tree)
end

@assert part2("C200B40A82") == 3 # finds the sum of 1 and 2, resulting in the value 3.
@assert part2("04005AC33890") == 54 # finds the product of 6 and 9, resulting in the value 54.
@assert part2("880086C3E88112") == 7 # finds the minimum of 7, 8, and 9, resulting in the value 7.
@assert part2("CE00C43D881120") == 9 # finds the maximum of 7, 8, and 9, resulting in the value 9.
@assert part2("D8005AC2A8F0") == 1 # produces 1, because 5 is less than 15.
@assert part2("F600BC2D8F") == 0 # produces 0, because 5 is not greater than 15.
@assert part2("9C005AC2F8F0") == 0 # produces 0, because 5 is not equal to 15.
@assert part2("9C0141080250320F1802104A08") == 1 # produces 1, because 1 + 3 = 2 * 2.
@time @show part2(input)
