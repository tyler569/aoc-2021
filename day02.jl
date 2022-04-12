include("./download.jl")

input = getinput(2021, 2)

sample = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""

function parseline(line)
    command, amount = split(line)
    amount = parse(Int, amount)
    (command, amount)
end

function parseinput(input)
    map(parseline, split(strip(input), "\n"))
end

function part1(input)
    commands = parseinput(input)

    horiz = 0
    depth = 0

    for (command, amount) in commands
        if command == "forward"
            horiz += amount
        elseif command == "up"
            depth -= amount
        elseif command == "down"
            depth += amount
        else
            error("Invalid command")
        end
    end
    horiz * depth
end

@assert part1(sample) == 150
@show part1(input)

function part2(input)
    commands = parseinput(input)

    horiz = 0
    depth = 0
    aim = 0

    for (command, amount) in commands
        if command == "forward"
            horiz += amount
            depth += amount * aim
        elseif command == "up"
            aim -= amount
        elseif command == "down"
            aim += amount
        else
            error("Invalid command")
        end
    end
    horiz * depth
end

@assert part2(sample) == 900
@show part2(input)
