function fib(n)
    a, b = BigInt(0), BigInt(1)
    while n > 0
        a, b = b, a+b
        n -= 1
    end
    b
end

for i in 1:30
    println(fib(i))
end
