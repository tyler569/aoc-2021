include("./download.jl")

input = getinput(2021, 17)

sample = "target area: x=20..30, y=-10..-5"

function parseinput(input)
    m = match(r"target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)", input)
    i = parse.(Int, (m[1], m[2], m[3], m[4]))
    (i[1]:i[2], i[3]:i[4])
end

function inrange(range, value)
    if in(value[1], range[1]) && in(value[2], range[2])
        true
    elseif value[2] < range[2].start
        :toolow
    elseif value[1] > range[1].start
        :tooright
    elseif value[1] < range[1].stop
        :tooleft
    else
        :above
    end
end

function path(range, vx, vy)
    x, y = 0, 0
    highesty = -Inf
    while inrange(range, (x, y)) != true && inrange(range, (x, y)) != :toolow
        x += vx
        y += vy
        vx += -sign(vx) # move 1 toward zero
        vy -= 1 # gravity
        if y > highesty
            highesty = y
        end
        @show x, y, vx, vy, highesty
    end
    (inrange(range, (x, y)), highesty)
end

function highpoints(range)
    hits = Int[]
    for vx in 0:range[1].stop # can't overshoot in one step
        for vy in -1000:1000
            result, high = path(range, vx, vy)
            if result == true
                push!(hits, high)
            end
        end
    end
    hits
end

function part1(input)
    range = parseinput(input)
    maximum(highpoints(range))
end

path(parseinput(sample), 6, 11)

exit()

@assert part1(sample) == 45
@time @show part1(input)

function part2(input)
    range = parseinput(input)
    length(highpoints(range))
end

@assert part2(sample) == 112
@time @show part2(input)
