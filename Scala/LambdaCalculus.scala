// File: LambdaCalculus.scala
// Author: Claude (Anthropic AI model)
// Date: 2024-07-29
// Description: Lambda Calculus implementation in Scala
// Usage: Copy this file into a Scala project and run it using `scala LambdaCalculus.scala`

object LambdaCalculus {
  // Lambda expression type
  type Expr[A] = (Expr[A] => A) => A

  // Step 1: Understand Lambda Expressions

  // Identity function
  def identity[A](x: A): A = x

  // Apply a lambda expression to an argument
  def apply[A](f: Expr[A], x: Expr[A]): A = f(x)

  // Step 2: Implement Church Booleans

  def lcTrue[A]: Expr[Expr[A]] = x => _ => x
  def lcFalse[A]: Expr[Expr[A]] = _ => y => y
  def lcIf[A](condition: Expr[Expr[A]], thenClause: Expr[A], elseClause: Expr[A]): A =
    apply(apply(condition, thenClause), elseClause)

  // Step 3: Implement Basic Combinators

  def iCombinator[A]: Expr[A] = x => x
  def kCombinator[A]: Expr[Expr[A]] = x => _ => x
  def kiCombinator[A]: Expr[Expr[A]] = _ => y => y

  // Step 4: Create Church Numerals

  def lcZero[A]: Expr[Expr[A]] = _ => x => x
  def lcSucc[A](n: Expr[Expr[A]]): Expr[Expr[A]] = f => x => f(n(f)(x))

  def churchToInt(n: Expr[Expr[Int]]): Int = n(x => x + 1)(0)

  // Step 5: Implement Basic Arithmetic

  def lcAdd[A](m: Expr[Expr[A]], n: Expr[Expr[A]]): Expr[Expr[A]] =
    f => x => m(f)(n(f)(x))

  def lcMult[A](m: Expr[Expr[A]], n: Expr[Expr[A]]): Expr[Expr[A]] =
    f => m(n(f))

  // Step 6: Implement Pairs

  def lcPair[A](x: Expr[A], y: Expr[A]): Expr[Expr[A]] =
    f => f(x)(y)

  def lcFirst[A](p: Expr[Expr[A]]): A =
    p(x => _ => x)

  def lcSecond[A](p: Expr[Expr[A]]): A =
    p(_ => y => y)

  // Step 7: Build Lists Using Pairs

  def lcNil[A]: Expr[Expr[A]] = lcPair(lcTrue, lcTrue)
  def lcCons[A](head: Expr[A], tail: Expr[Expr[A]]): Expr[Expr[A]] =
    lcPair(lcFalse, lcPair(head, tail))

  def lcIsNil[A](list: Expr[Expr[A]]): Boolean =
    lcFirst(list).asInstanceOf[Boolean]

  def lcHead[A](list: Expr[Expr[A]]): A =
    lcFirst(lcSecond(list))

  def lcTail[A](list: Expr[Expr[A]]): Expr[Expr[A]] =
    lcSecond(lcSecond(list))

  // Step 8: Implement Comparison Operations

  def lcIsZero[A](n: Expr[Expr[A]]): Boolean =
    n(_ => false)(true)

  def lcLeq[A](m: Expr[Expr[A]], n: Expr[Expr[A]]): Boolean =
    lcIsZero(lcSub(m, n))

  def lcEq[A](m: Expr[Expr[A]], n: Expr[Expr[A]]): Boolean =
    lcAnd(lcLeq(m, n), lcLeq(n, m))

  // Helper functions for Step 8
  def lcSub[A](m: Expr[Expr[A]], n: Expr[Expr[A]]): Expr[Expr[A]] =
    f => x => n(g => h => h(g(f)))(identity[A])(x)

  def lcAnd(a: Boolean, b: Boolean): Boolean = a && b

  // Step 9: Implement Higher-Order List Operations

  def lcMap[A](f: A => A, list: Expr[Expr[A]]): Expr[Expr[A]] =
    lcIf(lcIsNil(list),
         lcNil,
         lcCons(f(lcHead(list)), lcMap(f, lcTail(list))))

  def lcFilter[A](pred: A => Boolean, list: Expr[Expr[A]]): Expr[Expr[A]] =
    lcIf(lcIsNil(list),
         lcNil,
         lcIf(pred(lcHead(list)),
              lcCons(lcHead(list), lcFilter(pred, lcTail(list))),
              lcFilter(pred, lcTail(list))))

  def lcFold[A](f: (A, A) => A, acc: Expr[A], list: Expr[Expr[A]]): A =
    lcIf(lcIsNil(list),
         acc,
         lcFold(f, f(acc, lcHead(list)), lcTail(list)))

  // Step 10: Explore Recursion and Fixed-Point Combinators

  def yCombinator[A]: Expr[Expr[A]] =
    f => (x: Expr[A] => A) => f(y => x(x)(y))((x: Expr[A] => A) => f(y => x(x)(y)))

  def lcFactorial: Expr[Int] =
    yCombinator(f =>
      n => lcIf(lcIsZero(n),
                1,
                n * f(n - 1)))

  def main(args: Array[String]): Unit = {
    // Example usage
    val one = lcSucc(lcZero)
    val two = lcSucc(one)
    val three = lcAdd(one, two)

    println(s"1 + 2 = ${churchToInt(three)}")

    val fact5 = lcFactorial(5)
    println(s"5! = $fact5")
  }
}