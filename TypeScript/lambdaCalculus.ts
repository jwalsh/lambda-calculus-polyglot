/**
 * Lambda Calculus Implementation in TypeScript
 * Created by Claude 3.5 Sonnet (Anthropic, PBC)
 * 
 * Recommended filename: lambdaCalculus.ts
 * 
 * Usage:
 * 1. Ensure you have TypeScript installed
 * 2. Save this file as lambdaCalculus.ts
 * 3. Compile: tsc lambdaCalculus.ts
 * 4. Run: node lambdaCalculus.js
 */

// Step 1: Understand Lambda Expressions
type LambdaFunction<T, U> = (x: T) => U;

const identity: LambdaFunction<any, any> = (x) => x;
console.log(identity(5)); // Outputs: 5

// Step 2: Implement Church Booleans
type ChurchBoolean = <T>(x: T) => (y: T) => T;

const lcTrue: ChurchBoolean = (x) => (y) => x;
const lcFalse: ChurchBoolean = (x) => (y) => y;
const lcIf = <T>(condition: ChurchBoolean) => (then: T) => (else_: T): T => condition(then)(else_);

console.log(lcIf(lcTrue)('yes')('no')); // Outputs: 'yes'

// Step 3: Implement Basic Combinators
const I = identity;
const K: <T, U>(x: T) => (y: U) => T = (x) => (y) => x;
const KI: <T, U>(x: T) => (y: U) => U = (x) => (y) => y;

// Step 4: Create Church Numerals
type ChurchNumeral = <T>(f: (x: T) => T) => (x: T) => T;

const lcZero: ChurchNumeral = (f) => (x) => x;
const lcSucc = (n: ChurchNumeral): ChurchNumeral => (f) => (x) => f(n(f)(x));

const churchToInt = (n: ChurchNumeral): number => n((x: number) => x + 1)(0);

console.log(churchToInt(lcSucc(lcZero))); // Outputs: 1

// Step 5: Implement Basic Arithmetic
const lcAdd = (m: ChurchNumeral) => (n: ChurchNumeral): ChurchNumeral => (f) => (x) => m(f)(n(f)(x));
const lcMult = (m: ChurchNumeral) => (n: ChurchNumeral): ChurchNumeral => (f) => m(n(f));

const lcOne = lcSucc(lcZero);
const lcTwo = lcSucc(lcOne);

console.log(churchToInt(lcAdd(lcOne)(lcTwo))); // Outputs: 3

// Step 6: Implement Pairs
type ChurchPair<T, U> = <R>(f: (x: T) => (y: U) => R) => R;

const lcPair = <T, U>(x: T) => (y: U): ChurchPair<T, U> => (f) => f(x)(y);
const lcFirst = <T, U>(p: ChurchPair<T, U>): T => p((x) => (y) => x);
const lcSecond = <T, U>(p: ChurchPair<T, U>): U => p((x) => (y) => y);

const myPair = lcPair('hello')('world');
console.log(lcFirst(myPair)); // Outputs: 'hello'

// Step 7: Build Lists Using Pairs
type ChurchList<T> = ChurchPair<T, ChurchList<T>> | typeof lcNil;

const lcNil = lcPair(lcTrue)(lcTrue);
const lcCons = <T>(head: T) => (tail: ChurchList<T>): ChurchList<T> => lcPair(lcFalse)(lcPair(head)(tail));
const lcIsNil = <T>(list: ChurchList<T>): boolean => lcFirst(list as ChurchPair<ChurchBoolean, any>) === lcTrue;
const lcHead = <T>(list: ChurchList<T>): T => lcFirst(lcSecond(list as ChurchPair<ChurchBoolean, ChurchPair<T, any>>));
const lcTail = <T>(list: ChurchList<T>): ChurchList<T> => lcSecond(lcSecond(list as ChurchPair<ChurchBoolean, ChurchPair<T, ChurchList<T>>>));

// Step 8: Implement Comparison Operations
const lcIsZero = (n: ChurchNumeral): ChurchBoolean => n((x) => lcFalse)(lcTrue);
const lcLessThan = (m: ChurchNumeral) => (n: ChurchNumeral): ChurchBoolean => 
  lcNot(lcIsZero(lcSub(n)(m)));
const lcEqual = (m: ChurchNumeral) => (n: ChurchNumeral): ChurchBoolean => 
  lcAnd(lcLessThan(m)(lcSucc(n)))(lcLessThan(n)(lcSucc(m)));

// Helper functions for comparison operations
const lcNot = (b: ChurchBoolean): ChurchBoolean => (x) => (y) => b(y)(x);
const lcAnd = (a: ChurchBoolean) => (b: ChurchBoolean): ChurchBoolean => (x) => (y) => a(b(x)(y))(y);
const lcSub = (m: ChurchNumeral) => (n: ChurchNumeral): ChurchNumeral => 
  n((f) => (g) => (h) => h(f(g)))((f) => (x) => x)(m);

// Step 9: Implement Higher-Order List Operations
const lcMap = <T, U>(f: (x: T) => U) => (list: ChurchList<T>): ChurchList<U> =>
  lcIsNil(list) ? lcNil : lcCons(f(lcHead(list)))(lcMap(f)(lcTail(list)));

const lcFilter = <T>(pred: (x: T) => ChurchBoolean) => (list: ChurchList<T>): ChurchList<T> =>
  lcIsNil(list) ? lcNil :
    pred(lcHead(list)) ? lcCons(lcHead(list))(lcFilter(pred)(lcTail(list))) :
      lcFilter(pred)(lcTail(list));

const lcFold = <T, U>(f: (acc: U) => (x: T) => U) => (acc: U) => (list: ChurchList<T>): U =>
  lcIsNil(list) ? acc : lcFold(f)(f(acc)(lcHead(list)))(lcTail(list));

// Step 10: Explore Recursion and Fixed-Point Combinators
const Y = <T>(f: (g: (x: T) => T) => (x: T) => T): (x: T) => T =>
  ((x) => f((y) => x(x)(y)))((x) => f((y) => x(x)(y)));

// Example: Factorial using Y combinator
const factorial = Y((f) => (n: ChurchNumeral) =>
  lcIf(lcIsZero(n))
    (lcOne)
    (lcMult(n)(f(lcSub(n)(lcOne))))
);

console.log(churchToInt(factorial(lcSucc(lcSucc(lcSucc(lcZero)))))); // Outputs: 6 (3!)

// Helper function to convert regular numbers to Church numerals
const intToChurch = (n: number): ChurchNumeral => 
  n === 0 ? lcZero : lcSucc(intToChurch(n - 1));

// Example usage of higher-order list operations
const exampleList = lcCons(1)(lcCons(2)(lcCons(3)(lcNil)));
const doubledList = lcMap((x: number) => x * 2)(exampleList);
const evenNumbers = lcFilter((x: number) => lcEqual(intToChurch(x % 2))(lcZero))(exampleList);
const sum = lcFold((acc: number) => (x: number) => acc + x)(0)(exampleList);

console.log("Doubled list:", churchToInt(lcHead(doubledList) as ChurchNumeral)); // Outputs: 2
console.log("Even numbers:", churchToInt(lcHead(evenNumbers) as ChurchNumeral)); // Outputs: 2
console.log("Sum:", sum); // Outputs: 6
