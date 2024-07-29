// Lambda Calculus Implementation in Go
// Created by Claude 3.5 Sonnet (Anthropic, PBC)
// July 29, 2024
//
// Recommended filename: lambda_calculus.go
// Usage: Run `go run lambda_calculus.go` to execute the example code

package main

import (
	"fmt"
)

// LambdaExpr represents a lambda expression
type LambdaExpr func(LambdaExpr) LambdaExpr

// Step 1: Understand Lambda Expressions

// identity implements the identity function
func identity(x LambdaExpr) LambdaExpr {
	return x
}

// Step 2: Implement Church Booleans

// lcTrue implements Church encoding for true
func lcTrue(x LambdaExpr) LambdaExpr {
	return func(y LambdaExpr) LambdaExpr {
		return x
	}
}

// lcFalse implements Church encoding for false
func lcFalse(x LambdaExpr) LambdaExpr {
	return func(y LambdaExpr) LambdaExpr {
		return y
	}
}

// lcIf implements an if-then-else construct using Church booleans
func lcIf(condition, then, else_ LambdaExpr) LambdaExpr {
	return condition(then)(else_)
}

// Step 3: Implement Basic Combinators

// I combinator (identity)
func I(x LambdaExpr) LambdaExpr {
	return x
}

// K combinator (kestrel)
func K(x LambdaExpr) LambdaExpr {
	return func(y LambdaExpr) LambdaExpr {
		return x
	}
}

// KI combinator (kite)
func KI(x LambdaExpr) LambdaExpr {
	return func(y LambdaExpr) LambdaExpr {
		return y
	}
}

// Step 4: Create Church Numerals

// lcZero represents Church numeral zero
func lcZero(f LambdaExpr) LambdaExpr {
	return func(x LambdaExpr) LambdaExpr {
		return x
	}
}

// lcSucc implements the successor function for Church numerals
func lcSucc(n LambdaExpr) LambdaExpr {
	return func(f LambdaExpr) LambdaExpr {
		return func(x LambdaExpr) LambdaExpr {
			return f(n(f)(x))
		}
	}
}

// churchToInt converts a Church numeral to an integer
func churchToInt(n LambdaExpr) int {
	result := 0
	n(func(x LambdaExpr) LambdaExpr {
		result++
		return x
	})(nil)
	return result
}

// Step 5: Implement Basic Arithmetic

// lcAdd implements addition for Church numerals
func lcAdd(m, n LambdaExpr) LambdaExpr {
	return func(f LambdaExpr) LambdaExpr {
		return func(x LambdaExpr) LambdaExpr {
			return m(f)(n(f)(x))
		}
	}
}

// lcMult implements multiplication for Church numerals
func lcMult(m, n LambdaExpr) LambdaExpr {
	return func(f LambdaExpr) LambdaExpr {
		return m(n(f))
	}
}

// Step 6: Implement Pairs

// lcPair creates a pair of lambda expressions
func lcPair(x, y LambdaExpr) LambdaExpr {
	return func(f LambdaExpr) LambdaExpr {
		return f(x)(y)
	}
}

// lcFirst extracts the first element of a pair
func lcFirst(p LambdaExpr) LambdaExpr {
	return p(func(x LambdaExpr) LambdaExpr {
		return func(y LambdaExpr) LambdaExpr {
			return x
		}
	})
}

// lcSecond extracts the second element of a pair
func lcSecond(p LambdaExpr) LambdaExpr {
	return p(func(x LambdaExpr) LambdaExpr {
		return func(y LambdaExpr) LambdaExpr {
			return y
		}
	})
}

// Step 7: Build Lists Using Pairs

// lcNil represents an empty list
var lcNil = lcPair(lcTrue, lcTrue)

// lcCons constructs a list
func lcCons(head, tail LambdaExpr) LambdaExpr {
	return lcPair(lcFalse, lcPair(head, tail))
}

// lcIsNil checks if a list is empty
func lcIsNil(list LambdaExpr) LambdaExpr {
	return lcFirst(list)
}

// lcHead returns the first element of a list
func lcHead(list LambdaExpr) LambdaExpr {
	return lcFirst(lcSecond(list))
}

// lcTail returns the rest of a list (without the first element)
func lcTail(list LambdaExpr) LambdaExpr {
	return lcSecond(lcSecond(list))
}

// Step 8: Implement Comparison Operations

// lcIsZero checks if a Church numeral is zero
func lcIsZero(n LambdaExpr) LambdaExpr {
	return n(func(x LambdaExpr) LambdaExpr {
		return lcFalse
	})(lcTrue)
}

// lcLessThan checks if one Church numeral is less than another
func lcLessThan(m, n LambdaExpr) LambdaExpr {
	return lcIsZero(lcSub(m, n))
}

// lcEqual checks if two Church numerals are equal
func lcEqual(m, n LambdaExpr) LambdaExpr {
	return lcAnd(lcIsZero(lcSub(m, n)))(lcIsZero(lcSub(n, m)))
}

// Helper functions for comparison operations
func lcSub(m, n LambdaExpr) LambdaExpr {
	return n(lcPred)(m)
}

func lcPred(n LambdaExpr) LambdaExpr {
	return func(f LambdaExpr) LambdaExpr {
		return func(x LambdaExpr) LambdaExpr {
			return n(func(g LambdaExpr) LambdaExpr {
				return func(h LambdaExpr) LambdaExpr {
					return h(g(f))
				}
			})(func(u LambdaExpr) LambdaExpr { return x })(identity)
		}
	}
}

func lcAnd(a, b LambdaExpr) LambdaExpr {
	return func(x LambdaExpr) LambdaExpr {
		return func(y LambdaExpr) LambdaExpr {
			return a(b(x)(y))(y)
		}
	}
}

// Step 9: Implement Higher-Order List Operations

// lcMap applies a function to each element of a list
func lcMap(f, list LambdaExpr) LambdaExpr {
	return lcIf(lcIsNil(list))(
		lcNil,
		func(x LambdaExpr) LambdaExpr {
			return lcCons(f(lcHead(list)), lcMap(f, lcTail(list)))
		},
	)
}

// lcFilter creates a new list with elements that satisfy a predicate
func lcFilter(pred, list LambdaExpr) LambdaExpr {
	return lcIf(lcIsNil(list))(
		lcNil,
		func(x LambdaExpr) LambdaExpr {
			return lcIf(pred(lcHead(list)))(
				func(y LambdaExpr) LambdaExpr {
					return lcCons(lcHead(list), lcFilter(pred, lcTail(list)))
				},
				func(y LambdaExpr) LambdaExpr {
					return lcFilter(pred, lcTail(list))
				},
			)(nil)
		},
	)
}

// lcFold folds a list with an accumulator
func lcFold(f, acc, list LambdaExpr) LambdaExpr {
	return lcIf(lcIsNil(list))(
		acc,
		func(x LambdaExpr) LambdaExpr {
			return lcFold(f, f(acc)(lcHead(list)), lcTail(list))
		},
	)
}

// Step 10: Explore Recursion and Fixed-Point Combinators

// Y combinator for implementing recursion
func Y(f LambdaExpr) LambdaExpr {
	return func(x LambdaExpr) LambdaExpr {
		return f(func(y LambdaExpr) LambdaExpr {
			return x(x)(y)
		})
	}(func(x LambdaExpr) LambdaExpr {
		return f(func(y LambdaExpr) LambdaExpr {
			return x(x)(y)
		})
	})
}

// Example: Factorial using Y combinator
func factorial() LambdaExpr {
	return Y(func(f LambdaExpr) LambdaExpr {
		return func(n LambdaExpr) LambdaExpr {
			return lcIf(lcIsZero(n))(
				lcSucc(lcZero),
				func(x LambdaExpr) LambdaExpr {
					return lcMult(n)(f(lcPred(n)))
				},
			)
		}
	})
}

func main() {
	// Example usage
	lcOne := lcSucc(lcZero)
	lcTwo := lcSucc(lcOne)
	lcThree := lcSucc(lcTwo)

	fmt.Println("1 + 2 =", churchToInt(lcAdd(lcOne, lcTwo)))
	fmt.Println("2 * 3 =", churchToInt(lcMult(lcTwo, lcThree)))

	myPair := lcPair(lcOne, lcTwo)
	fmt.Println("First of (1, 2) =", churchToInt(lcFirst(myPair)))
	fmt.Println("Second of (1, 2) =", churchToInt(lcSecond(myPair)))

	myList := lcCons(lcOne, lcCons(lcTwo, lcCons(lcThree, lcNil)))
	fmt.Println("Head of [1, 2, 3] =", churchToInt(lcHead(myList)))

	fmt.Println("3! =", churchToInt(factorial()(lcThree)))
}
