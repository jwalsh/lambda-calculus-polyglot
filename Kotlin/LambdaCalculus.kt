/**
 * Lambda Calculus Implementation in Kotlin
 * Created by Claude (Anthropic, PBC), version 3.5 Sonnet
 * 
 * Recommended filename: LambdaCalculus.kt
 * 
 * Usage: This file can be run in a Kotlin REPL or compiled and executed
 * as a Kotlin program. Each section demonstrates different concepts of
 * Lambda Calculus implemented in Kotlin.
 */

// Step 1: Understand Lambda Expressions
typealias LambdaExpr<T> = (T) -> T

val identity: LambdaExpr<Int> = { x -> x }
println(identity(5)) // Output: 5

// Step 2: Implement Church Booleans
typealias ChurchBoolean = <T> (T, T) -> T

val lcTrue: ChurchBoolean = { t, _ -> t }
val lcFalse: ChurchBoolean = { _, f -> f }
val lcIf: (ChurchBoolean, () -> Any, () -> Any) -> Any = { condition, then, else -> condition(then(), else()) }

println(lcIf(lcTrue, { "yes" }, { "no" })) // Output: yes

// Step 3: Implement Basic Combinators
val I: LambdaExpr<Any> = { x -> x }
val K: (Any) -> (Any) -> Any = { x -> { _ -> x } }
val KI: (Any) -> (Any) -> Any = { _ -> { y -> y } }

// Step 4: Create Church Numerals
typealias ChurchNumeral = (LambdaExpr<Int>) -> LambdaExpr<Int>

val lcZero: ChurchNumeral = { _ -> { x -> x } }
val lcSucc: (ChurchNumeral) -> ChurchNumeral = { n -> { f -> { x -> f(n(f)(x)) } } }

fun churchToInt(n: ChurchNumeral): Int = n({ it + 1 })(0)

println(churchToInt(lcSucc(lcZero))) // Output: 1

// Step 5: Implement Basic Arithmetic
val lcAdd: (ChurchNumeral) -> (ChurchNumeral) -> ChurchNumeral = { m -> { n -> { f -> { x -> m(f)(n(f)(x)) } } } }
val lcMult: (ChurchNumeral) -> (ChurchNumeral) -> ChurchNumeral = { m -> { n -> { f -> m(n(f)) } } }

val lcOne = lcSucc(lcZero)
val lcTwo = lcSucc(lcOne)

println(churchToInt(lcAdd(lcOne)(lcTwo))) // Output: 3

// Step 6: Implement Pairs
typealias Pair<T> = ((T, T) -> T) -> T

fun <T> lcPair(x: T, y: T): Pair<T> = { f -> f(x, y) }
fun <T> lcFirst(p: Pair<T>): T = p { x, _ -> x }
fun <T> lcSecond(p: Pair<T>): T = p { _, y -> y }

val myPair = lcPair("hello", "world")
println(lcFirst(myPair)) // Output: hello

// Step 7: Build Lists Using Pairs
typealias LCList<T> = Pair<T?>

val lcNil: LCList<Any?> = lcPair(null, null)
fun <T> lcCons(head: T, tail: LCList<T>): LCList<T> = lcPair(head, tail)
fun <T> lcIsNil(list: LCList<T>): Boolean = lcFirst(list) == null
fun <T> lcHead(list: LCList<T>): T? = lcFirst(list)
fun <T> lcTail(list: LCList<T>): LCList<T> = lcSecond(list) as LCList<T>

// Step 8: Implement Comparison Operations
val lcIsZero: (ChurchNumeral) -> ChurchBoolean = { n -> n({ _ -> lcFalse })(lcTrue) }
val lcLessThan: (ChurchNumeral) -> (ChurchNumeral) -> ChurchBoolean = { m -> { n ->
    n({ _ -> lcFalse })({ f ->
        m({ _ -> lcTrue })(f)
    })
} }
val lcEqual: (ChurchNumeral) -> (ChurchNumeral) -> ChurchBoolean = { m -> { n ->
    lcAnd(lcLessThan(m)(n))(lcLessThan(n)(m))
} }

// Helper functions for boolean operations
val lcAnd: (ChurchBoolean) -> (ChurchBoolean) -> ChurchBoolean = { p -> { q -> p(q)(p) } }
val lcOr: (ChurchBoolean) -> (ChurchBoolean) -> ChurchBoolean = { p -> { q -> p(p)(q) } }
val lcNot: (ChurchBoolean) -> ChurchBoolean = { p -> p(lcFalse)(lcTrue) }

// Step 9: Implement Higher-Order List Operations
fun <T, R> lcMap(f: (T) -> R, list: LCList<T>): LCList<R> =
    if (lcIsNil(list)) lcNil
    else lcCons(f(lcHead(list)!!), lcMap(f, lcTail(list)))

fun <T> lcFilter(predicate: (T) -> Boolean, list: LCList<T>): LCList<T> =
    if (lcIsNil(list)) lcNil
    else if (predicate(lcHead(list)!!)) lcCons(lcHead(list)!!, lcFilter(predicate, lcTail(list)))
    else lcFilter(predicate, lcTail(list))

fun <T, R> lcFold(f: (T, R) -> R, initial: R, list: LCList<T>): R =
    if (lcIsNil(list)) initial
    else lcFold(f, f(lcHead(list)!!, initial), lcTail(list))

// Step 10: Explore Recursion and Fixed-Point Combinators
typealias Recursive<T> = ((T) -> T) -> (T) -> T

val Y: Recursive<(Int) -> Int> = { f ->
    { x -> f({ y -> x(x)(y) })(x) }({ x -> f({ y -> x(x)(y) }) })
}

// Example: Factorial using Y combinator
val factorial = Y { f ->
    { n ->
        if (n <= 1) 1
        else n * f(n - 1)
    }
}

println(factorial(5)) // Output: 120

// Usage examples
fun main() {
    // Church numerals
    val lcThree = lcSucc(lcTwo)
    println("3 as Church numeral: ${churchToInt(lcThree)}")

    // List operations
    val list = lcCons(1, lcCons(2, lcCons(3, lcNil)))
    val doubled = lcMap({ it * 2 }, list)
    println("Doubled list: ${lcToString(doubled)}")

    val evens = lcFilter({ it % 2 == 0 }, list)
    println("Even numbers: ${lcToString(evens)}")

    val sum = lcFold({ a, b -> a + b }, 0, list)
    println("Sum of list: $sum")

    // Factorial
    println("Factorial of 5: ${factorial(5)}")
}

// Helper function to convert LCList to String for printing
fun <T> lcToString(list: LCList<T>): String {
    fun helper(l: LCList<T>, acc: List<T>): List<T> =
        if (lcIsNil(l)) acc
        else helper(lcTail(l), acc + lcHead(l)!!)
    return helper(list, emptyList()).toString()
}
