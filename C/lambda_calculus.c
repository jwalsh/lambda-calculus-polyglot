/*
 * Lambda Calculus Implementation in C
 * Created by Claude (Anthropic, PBC), 2024
 * 
 * Recommended filename: lambda_calculus.c
 * 
 * Usage:
 * Compile: gcc -o lambda_calculus lambda_calculus.c
 * Run: ./lambda_calculus
 */

#include <stdio.h>
#include <stdlib.h>

// Step 1: Lambda Expressions
// In C, we'll represent lambda expressions as function pointers

typedef void* (*lambda)(void*);

void* identity(void* x) {
    return x;
}

// Step 2: Church Booleans
void* lc_true(void* x, void* y) {
    return x;
}

void* lc_false(void* x, void* y) {
    return y;
}

void* lc_if(void* (*condition)(void*, void*), void* then_clause, void* else_clause) {
    return condition(then_clause, else_clause);
}

// Step 3: Basic Combinators
// I (Identity) is the same as the identity function above
// K (Kestrel)
void* K(void* x) {
    return (void* (*)(void*))lc_true;
}

// KI (Kite)
void* KI(void* x) {
    return (void* (*)(void*))lc_false;
}

// Step 4: Church Numerals
typedef void* (*church_numeral)(void* (*f)(void*), void* x);

void* lc_zero(void* (*f)(void*), void* x) {
    return x;
}

church_numeral lc_succ(church_numeral n) {
    return (church_numeral)((void* (*)(void* (*)(void*), void*))
        lambda(f) lambda(x) f(n(f, x)));
}

int church_to_int(church_numeral n) {
    int result = 0;
    n((void* (*)(void*))((void* (*)(int*))lambda(x) (*x)++), &result);
    return result;
}

// Step 5: Basic Arithmetic
church_numeral lc_add(church_numeral m, church_numeral n) {
    return (church_numeral)((void* (*)(void* (*)(void*), void*))
        lambda(f) lambda(x) m(f, n(f, x)));
}

church_numeral lc_mult(church_numeral m, church_numeral n) {
    return (church_numeral)((void* (*)(void* (*)(void*), void*))
        lambda(f) m((void* (*)(void*))n(f)));
}

// Step 6: Pairs
typedef void* (*pair)(void* (*f)(void*, void*));

pair lc_pair(void* x, void* y) {
    return (pair)lambda(f) f(x, y);
}

void* lc_first(pair p) {
    return p((void* (*)(void*, void*))lambda(x, y) x);
}

void* lc_second(pair p) {
    return p((void* (*)(void*, void*))lambda(x, y) y);
}

// Step 7: Lists using Pairs
pair lc_nil = NULL;

pair lc_cons(void* head, pair tail) {
    return lc_pair(head, tail);
}

int lc_is_nil(pair list) {
    return list == NULL;
}

void* lc_head(pair list) {
    return lc_first(list);
}

pair lc_tail(pair list) {
    return lc_second(list);
}

// Step 8: Comparison Operations
int lc_is_zero(church_numeral n) {
    return church_to_int(n) == 0;
}

int lc_less_than(church_numeral m, church_numeral n) {
    return church_to_int(m) < church_to_int(n);
}

int lc_equal(church_numeral m, church_numeral n) {
    return church_to_int(m) == church_to_int(n);
}

// Step 9: Higher-Order List Operations
pair lc_map(void* (*f)(void*), pair list) {
    if (lc_is_nil(list)) return lc_nil;
    return lc_cons(f(lc_head(list)), lc_map(f, lc_tail(list)));
}

pair lc_filter(int (*pred)(void*), pair list) {
    if (lc_is_nil(list)) return lc_nil;
    void* head = lc_head(list);
    pair tail = lc_filter(pred, lc_tail(list));
    return pred(head) ? lc_cons(head, tail) : tail;
}

void* lc_fold(void* (*f)(void*, void*), void* acc, pair list) {
    if (lc_is_nil(list)) return acc;
    return lc_fold(f, f(acc, lc_head(list)), lc_tail(list));
}

// Step 10: Recursion and Fixed-Point Combinators
typedef void* (*Y_func)(Y_func);

Y_func Y_combinator(Y_func f) {
    return (Y_func)lambda(x) f(x(x))(lambda(x) f(x(x)));
}

// Example usage of Y combinator for factorial
int factorial_helper(Y_func self, int n) {
    if (n == 0) return 1;
    return n * (int)(long)self(self, n - 1);
}

Y_func factorial_Y = lambda(self) lambda(n) factorial_helper(self, (int)(long)n);

int main() {
    // Test identity
    printf("Identity of 5: %d\n", (int)(long)identity((void*)5));

    // Test Church booleans
    printf("lc_if with lc_true: %s\n", (char*)lc_if(lc_true, "yes", "no"));
    printf("lc_if with lc_false: %s\n", (char*)lc_if(lc_false, "yes", "no"));

    // Test Church numerals and arithmetic
    church_numeral one = lc_succ((church_numeral)lc_zero);
    church_numeral two = lc_succ(one);
    printf("one + two = %d\n", church_to_int(lc_add(one, two)));
    printf("two * two = %d\n", church_to_int(lc_mult(two, two)));

    // Test pairs
    pair my_pair = lc_pair("hello", "world");
    printf("First of pair: %s\n", (char*)lc_first(my_pair));
    printf("Second of pair: %s\n", (char*)lc_second(my_pair));

    // Test lists
    pair my_list = lc_cons((void*)1, lc_cons((void*)2, lc_cons((void*)3, lc_nil)));
    printf("Head of list: %d\n", (int)(long)lc_head(my_list));

    // Test Y combinator (factorial)
    int n = 5;
    int result = (int)(long)Y_combinator(factorial_Y)((void*)(long)n);
    printf("Factorial of %d: %d\n", n, result);

    return 0;
}
