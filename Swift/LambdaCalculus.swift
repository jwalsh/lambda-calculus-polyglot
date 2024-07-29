// File: LambdaCalculus.swift
// Author: Claude (Anthropic AI model)
// Date: 2024-07-29
// Description: Lambda Calculus implementation in Swift
// Usage: Copy this file into a Swift project and run it

import Foundation

// Lambda expression type
typealias Expr<T> = (Expr<T>) -> T

// Step 1: Understand Lambda Expressions

// Identity function
func identity<T>(_ x: T) -> T {
    return x
}

// Apply a lambda expression to an argument
func apply<T>(_ f: @escaping Expr<T>, _ x: @escaping Expr<T>) -> T {
    return f(x)
}

// Step 2: Implement Church Booleans

func lcTrue<T>() -> Expr<Expr<T>> {
    return { x in { _ in x } }
}

func lcFalse<T>() -> Expr<Expr<T>> {
    return { _ in { y in y } }
}

func lcIf<T>(_ condition: @escaping Expr<Expr<T>>, _ then: @escaping Expr<T>, _ else: @escaping Expr<T>) -> T {
    return apply(apply(condition, then), else)
}

// Step 3: Implement Basic Combinators

func iCombinator<T>() -> Expr<T> {
    return { x in x }
}

func kCombinator<T>() -> Expr<Expr<T>> {
    return { x in { _ in x } }
}

func kiCombinator<T>() -> Expr<Expr<T>> {
    return { _ in { y in y } }
}

// Step 4: Create Church Numerals

func lcZero<T>() -> Expr<Expr<T>> {
    return { _ in { x in x } }
}

func lcSucc<T>(_ n: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return { f in { x in f(n(f)(x)) } }
}

func churchToInt(_ n: @escaping Expr<Expr<Int>>) -> Int {
    return n({ x in x + 1 })(0)
}

// Step 5: Implement Basic Arithmetic

func lcAdd<T>(_ m: @escaping Expr<Expr<T>>, _ n: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return { f in { x in m(f)(n(f)(x)) } }
}

func lcMult<T>(_ m: @escaping Expr<Expr<T>>, _ n: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return { f in m(n(f)) }
}

// Step 6: Implement Pairs

func lcPair<T>(_ x: @escaping Expr<T>, _ y: @escaping Expr<T>) -> Expr<Expr<T>> {
    return { f in f(x)(y) }
}

func lcFirst<T>(_ p: @escaping Expr<Expr<T>>) -> T {
    return p({ x in { _ in x } })
}

func lcSecond<T>(_ p: @escaping Expr<Expr<T>>) -> T {
    return p({ _ in { y in y } })
}

// Step 7: Build Lists Using Pairs

func lcNil<T>() -> Expr<Expr<T>> {
    return lcPair(lcTrue(), lcTrue())
}

func lcCons<T>(_ head: @escaping Expr<T>, _ tail: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return lcPair(lcFalse(), lcPair(head, tail))
}

func lcIsNil<T>(_ list: @escaping Expr<Expr<T>>) -> Bool {
    return lcFirst(list) as! Bool
}

func lcHead<T>(_ list: @escaping Expr<Expr<T>>) -> T {
    return lcFirst(lcSecond(list))
}

func lcTail<T>(_ list: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return lcSecond(lcSecond(list))
}

// Step 8: Implement Comparison Operations

func lcIsZero<T>(_ n: @escaping Expr<Expr<T>>) -> Bool {
    return n({ _ in false })(true)
}

func lcLeq<T>(_ m: @escaping Expr<Expr<T>>, _ n: @escaping Expr<Expr<T>>) -> Bool {
    return lcIsZero(lcSub(m, n))
}

func lcEq<T>(_ m: @escaping Expr<Expr<T>>, _ n: @escaping Expr<Expr<T>>) -> Bool {
    return lcAnd(lcLeq(m, n), lcLeq(n, m))
}

// Helper functions for Step 8
func lcSub<T>(_ m: @escaping Expr<Expr<T>>, _ n: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return { f in { x in n({ g in { h in h(g(f)) } })(identity)(x) } }
}

func lcAnd(_ a: Bool, _ b: Bool) -> Bool {
    return a && b
}

// Step 9: Implement Higher-Order List Operations

func lcMap<T>(_ f: @escaping (T) -> T, _ list: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return lcIf(lcIsNil(list) as! Expr<Expr<T>>,
                lcNil(),
                lcCons({ f(lcHead(list)) }, { lcMap(f, lcTail(list)) }))
}

func lcFilter<T>(_ pred: @escaping (T) -> Bool, _ list: @escaping Expr<Expr<T>>) -> Expr<Expr<T>> {
    return lcIf(lcIsNil(list) as! Expr<Expr<T>>,
                lcNil(),
                lcIf({ pred(lcHead(list)) } as! Expr<Expr<T>>,
                     lcCons({ lcHead(list) }, { lcFilter(pred, lcTail(list)) }),
                     { lcFilter(pred, lcTail(list)) }))
}

func lcFold<T>(_ f: @escaping (T, T) -> T, _ acc: @escaping Expr<T>, _ list: @escaping Expr<Expr<T>>) -> T {
    return lcIf(lcIsNil(list) as! Expr<Expr<T>>,
                acc,
                { lcFold(f, { f(acc(), lcHead(list)) }, lcTail(list)) })()
}

// Step 10: Explore Recursion and Fixed-Point Combinators

func yCombinator<T>() -> Expr<Expr<T>> {
    return { f in
        { x in f({ y in x(x)(y) }) }({ x in f({ y in x(x)(y) }) })
    }
}

func lcFactorial() -> Expr<Int> {
    return yCombinator()({ f in
        { n in
            lcIf({ lcIsZero({ n } as! Expr<Expr<Int>>) } as! Expr<Expr<Int>>,
                 { 1 },
                 { n * f(n - 1) })
        }
    })
}

// Example usage
let one = lcSucc(lcZero())
let two = lcSucc(one)
let three = lcAdd(one, two)

print("1 + 2 =", churchToInt(three))

let fact5 = lcFactorial()(5)
print("5! =", fact5)