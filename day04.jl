include("./download.jl")

input = getinput(2021, 4)

sample = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

function parseinput(input)
    draw, boards... = split(input, "\n\n")
    draw = map(x -> parse(Int, x), split(draw, ","))

    boards = map(board -> split(board), boards)
    boardlen = Int(sqrt(length(boards[1])))
    boards = map(board -> map(i -> parse(Int, i), board), boards)
    boards = map(board -> reshape(board, boardlen, boardlen), boards)

    (draw, boards)
end

function boardwins(board)
    dimension = size(board)[1]
    win = trues(dimension)

    for row in 1:dimension
        if all(board[row, :] .== true)
            return true
        end
    end

    for column in 1:dimension
        if all(board[:, column] .== true)
            return true
        end
    end

    false
end

function boardscore(board, hits, draw)
    board .*= .!hits
    sum(board) * draw
end


function part1(input)
    (draws, boards) = parseinput(input)
    boardlen = size(boards[1])[1]

    hits = map(board -> falses(boardlen, boardlen), boards)

    for draw in draws
        for (index, board) in Iterators.enumerate(boards)
            hits[index] .+= (board .== draw)
        end

        for (index, board) in Iterators.enumerate(boards)
            if boardwins(hits[index])
                return boardscore(board, hits[index], draw)
            end
        end
    end

    println("No one won :(")
    exit()
end

@assert part1(sample) == 4512
@show part1(input)

function part2(input)
    (draws, boards) = parseinput(input)
    boardlen = size(boards[1])[1]

    hits = map(board -> falses(boardlen, boardlen), boards)
    boardswon = trues(length(boards))

    for draw in draws
        for (index, board) in Iterators.enumerate(boards)
            hits[index] .+= (board .== draw)
        end

        for (index, board) in Iterators.enumerate(boards)
            if boardwins(hits[index])
                boardswon[index] = false
                if count(boardswon) == 0
                    return boardscore(board, hits[index], draw)
                end
            end
        end
    end

    println("No one won last :(")
    exit()
end

@assert part2(sample) == 1924
@show part2(input)
