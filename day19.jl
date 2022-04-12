using Combinatorics
using LinearAlgebra

include("./download.jl")

input = getinput(2021, 19)

sample = """
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
"""

function parsescanner(scanner)
    lines = split(scanner, "\n")[2:end]
    linere = r"(-?\d+),(-?\d+),(-?\d+)"
    strings = map(l -> match(linere, l), lines)
    map(m -> parse.(Int, [m[1] m[2] m[3] "1"]), strings)
end

function parseinput(input)
    scanners = split(strip(input), "\n\n")
    map(parsescanner, scanners)
end

function maxdelta(p1, p2)
    maximum([abs(p2[1] - p1[1]), abs(p2[2] - p1[2]), abs(p2[3] - p1[3])])
end

function tryorient(knownpoints, scanner)
    for candidate in scanner
        for point in knownpoints
            for (a, b, c) in permutations([1, 2, 3])
                for (fx, fy, fz) in [(x, y, z) for x = -1:2:1, y = -1:2:1, z = -1:2:1]
                    sx = point[1] - candidate[a]*fx
                    sy = point[2] - candidate[b]*fy
                    sz = point[3] - candidate[c]*fz
                    tr = [  0  0  0  0
                            0  0  0  0
                            0  0  0  0
                           sx sy sz  1]
                    tr[a, 1] = fx
                    tr[b, 2] = fy
                    tr[c, 3] = fz

                    if !isapprox(det(tr), 1)
                        continue
                    end

                    candidateset = map(p -> p * tr, scanner)
                    matches = filter(p -> in(p, knownpoints), candidateset)
                    if length(matches) >= 12
                        return tr
                    end
                end
            end
        end
    end
end

function allpoints(scanners)
    knownpoints = Set(scanners[1])
    scannerposs = []
    popat!(scanners, 1)
    n = 1
    lastloop = length(scanners)

    while length(scanners) != 0
        scanner = scanners[n]
        matrix = tryorient(knownpoints, scanner)
        if matrix != nothing
            println("Accepting scanners[$n] @ $matrix ($(scanner[1]) -> $(scanner[1] * matrix))")
            push!(scannerposs, matrix[4, 1:3])
            newfixedset = map(p -> p * matrix, scanner)
            union!(knownpoints, newfixedset)
            popat!(scanners, n)
        end
        if length(scanners) == 0
            break
        end
            
        n %= length(scanners)
        n += 1
        if n == 1 && length(scanners) == lastloop
            println("Not going anywhere fast")
            @show map(first, scanners)
            @show length(knownpoints)
            @show knownpoints
            exit()
        elseif n == 1
            lastloop = length(scanners)
        end
    end
    knownpoints, scannerposs
end

function part1(input)
    scanners = parseinput(input)
    points, scannerposs = allpoints(scanners)
    length(points)
end

# @assert part1(sample) == 79
# @time @show part1(input)

function distance(x, y)
    abs(y[1] - x[1]) + abs(y[2] - x[2]) + abs(y[3] - x[3])
end

function part2(input)
    scanners = parseinput(input)
    points, scannerposs = allpoints(scanners)
    @show maximum(pair -> distance(pair[1], pair[2]), permutations(scannerposs, 2))
end

@assert part2(sample) == 3621
@time @show part2(input)
