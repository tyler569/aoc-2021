include("./download.jl")

input = getinput(2021, 13)

sample = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""

function parseinput(input)
    points, folds = split(strip(input), "\n\n")
    mpoints = map(line -> match(r"(\d+),(\d+)", line), split(points, "\n"))
    ppoints = map(m -> (parse(Int, m[1]), parse(Int, m[2])), mpoints)
    mfolds = map(line -> match(r"fold along (\w)=(\d+)", line), split(folds, "\n"))
    pfolds = map(m -> (m[1], parse(Int, m[2])), mfolds)

    ppoints, pfolds
end

function buildboard(points)
    board = Dict()
    for point in points
        board[point] = true
    end
    board
end

function foldboard(board, fold)
    newboard = Dict()
    for point in keys(board)
        if fold[1] == "x" && point[1] > fold[2]
            newboard[(-point[1] + 2*fold[2], point[2])] = true
        elseif fold[1] == "y" && point[2] > fold[2]
            newboard[(point[1], -point[2] + 2*fold[2])] = true
        else
            newboard[point] = true
        end
    end
    newboard
end

function part1(input)
    (points, folds) = parseinput(input)
    board = buildboard(points)
    newboard = foldboard(board, folds[1])
    length(newboard)
end

@assert part1(sample) == 17
@time @show part1(input)

function printboard(board)
    lx = maximum(x for (x, y) in keys(board))
    ly = maximum(y for (x, y) in keys(board))

    for y in 0:ly
        for x in 0:lx
            if haskey(board, (x, y))
                print("#")
            else
                print(" ")
            end
        end
        println()
    end
end

function part2(input)
    (points, folds) = parseinput(input)
    board = buildboard(points)
    for fold in folds
        board = foldboard(board, fold)
    end
    printboard(board)
end

@show part2(sample)
@time @show part2(input)
