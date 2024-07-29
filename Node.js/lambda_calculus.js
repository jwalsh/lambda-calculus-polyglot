/**
 * Lambda Calculus Implementation in Node.js
 * Created by Claude 3.5 Sonnet (Anthropic, PBC)
 * 
 * Recommended filename: lambda_calculus.js
 * 
 * Usage: 
 * 1. Save this file as lambda_calculus.js
 * 2. Run with Node.js: node lambda_calculus.js
 * 3. Alternatively, you can import functions from this file in your own Node.js scripts
 */

// Step 1: Understand Lambda Expressions
const identity = x => x;
console.log(identity(5)); // 5

// Step 2: Implement Church Booleans
const lcTrue = x => y => x;
const lcFalse = x => y => y;
const lcIf = condition => then => else_ => condition(then)(else_);

console.log(lcIf(lcTrue)('yes')('no')); // 'yes'

// Step 3: Implement Basic Combinators
const I = x => x; // Identity
const K = x => y => x; // Kestrel
const KI = x => y => y; // Kite

// Step 4: Create Church Numerals
const lcZero = f => x => x;
const lcSucc = n => f => x => f(n(f)(x));

const churchToInt = n => n(x => x + 1)(0);

console.log(churchToInt(lcSucc(lcZero))); // 1

// Step 5: Implement Basic Arithmetic
const lcAdd = m => n => f => x => m(f)(n(f)(x));
const lcMult = m => n => f => m(n(f));

const lcOne = lcSucc(lcZero);
const lcTwo = lcSucc(lcOne);

console.log(churchToInt(lcAdd(lcOne)(lcTwo))); // 3

// Step 6: Implement Pairs
const lcPair = x => y => f => f(x)(y);
const lcFirst = p => p(x => y => x);
const lcSecond = p => p(x => y => y);

const myPair = lcPair('hello')('world');
console.log(lcFirst(myPair)); // 'hello'

// Step 7: Build Lists Using Pairs
const lcNil = lcPair(lcTrue)(lcTrue);
const lcCons = x => xs => lcPair(lcFalse)(lcPair(x)(xs));
const lcIsNil = xs => lcFirst(xs);
const lcHead = xs => lcFirst(lcSecond(xs));
const lcTail = xs => lcSecond(lcSecond(xs));

// Step 8: Implement Comparison Operations
const lcIsZero = n => n(x => lcFalse)(lcTrue);
const lcLessThan = m => n => lcIsZero(lcSub(m)(n));
const lcEqual = m => n => lcAnd(lcLessThan(m)(n))(lcLessThan(n)(m));

// Helper functions for comparison operations
const lcAnd = p => q => p(q)(p);
const lcSub = m => n => n(lcPred)(m);
const lcPred = n => f => x => n(g => h => h(g(f)))(y => x)(I);

// Step 9: Implement Higher-Order List Operations
const lcMap = f => xs => lcIsNil(xs) ? lcNil : lcCons(f(lcHead(xs)))(lcMap(f)(lcTail(xs)));
const lcFilter = p => xs => lcIsNil(xs) ? lcNil : lcIf(p(lcHead(xs)))
                                                   (lcCons(lcHead(xs))(lcFilter(p)(lcTail(xs))))
                                                   (lcFilter(p)(lcTail(xs)));
const lcFold = f => acc => xs => lcIsNil(xs) ? acc : lcFold(f)(f(acc)(lcHead(xs)))(lcTail(xs));

// Step 10: Explore Recursion and Fixed-Point Combinators
const Y = f => (x => f(y => x(x)(y)))(x => f(y => x(x)(y)));

// Example: Factorial using Y combinator
const factorial = Y(f => n => lcIsZero(n) ? lcOne : lcMult(n)(f(lcPred(n))));

console.log(churchToInt(factorial(lcTwo))); // 2

// Helper function to convert JavaScript numbers to Church numerals
const intToChurch = n => {
    if (n === 0) return lcZero;
    return lcSucc(intToChurch(n - 1));
};

// Example usage of higher-order functions
const exampleList = lcCons(intToChurch(1))(lcCons(intToChurch(2))(lcCons(intToChurch(3))(lcNil)));
const doubleList = lcMap(n => lcMult(n)(lcTwo))(exampleList);
const evenList = lcFilter(n => lcIsZero(lcMod(n)(lcTwo)))(exampleList);
const sum = lcFold(lcAdd)(lcZero)(exampleList);

console.log('Double list:', churchToInt(lcHead(doubleList))); // 2
console.log('Even list:', churchToInt(lcHead(evenList))); // 2
console.log('Sum:', churchToInt(sum)); // 6

// Helper function for modulo operation
const lcMod = m => n => Y(f => a => b => lcLessThan(a)(b) ? a : f(lcSub(a)(b))(b))(m)(n);
