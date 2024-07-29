// File: lambda_calculus.rs
// Author: Claude (Anthropic AI model)
// Date: 2024-07-29
// Description: Lambda Calculus implementation in Rust
// Usage: Run with `cargo run` in a Rust project directory with this file in src/

use std::rc::Rc;

// Lambda expression type
type Expr = Rc<dyn Fn(Rc<dyn Fn(Expr) -> Expr>) -> Expr>;

// Step 1: Understand Lambda Expressions

// Identity function
fn identity(x: Expr) -> Expr {
    x
}

// Apply a lambda expression to an argument
fn apply(f: Expr, x: Expr) -> Expr {
    f(Rc::new(move |y| x.clone()))
}

// Step 2: Implement Church Booleans

fn lc_true() -> Expr {
    Rc::new(|x| Rc::new(move |y| x(Rc::new(identity))))
}

fn lc_false() -> Expr {
    Rc::new(|x| Rc::new(move |y| y(Rc::new(identity))))
}

fn lc_if(condition: Expr, then_clause: Expr, else_clause: Expr) -> Expr {
    apply(apply(condition, then_clause), else_clause)
}

// Step 3: Implement Basic Combinators

fn i_combinator() -> Expr {
    Rc::new(|x| x(Rc::new(identity)))
}

fn k_combinator() -> Expr {
    Rc::new(|x| Rc::new(move |y| x(Rc::new(identity))))
}

fn ki_combinator() -> Expr {
    Rc::new(|x| Rc::new(move |y| y(Rc::new(identity))))
}

// Step 4: Create Church Numerals

fn lc_zero() -> Expr {
    Rc::new(|f| Rc::new(|x| x(Rc::new(identity))))
}

fn lc_succ(n: Expr) -> Expr {
    Rc::new(move |f| Rc::new(move |x| {
        f(Rc::new(move |y| apply(apply(n.clone(), f.clone()), x.clone())))
    }))
}

fn church_to_int(n: Expr) -> i32 {
    let mut result = 0;
    apply(
        n,
        Rc::new(|x| {
            result += 1;
            x
        }),
    );
    result
}

// Step 5: Implement Basic Arithmetic

fn lc_add(m: Expr, n: Expr) -> Expr {
    Rc::new(move |f| {
        Rc::new(move |x| {
            apply(
                apply(m.clone(), f.clone()),
                apply(apply(n.clone(), f.clone()), x.clone()),
            )
        })
    })
}

fn lc_mult(m: Expr, n: Expr) -> Expr {
    Rc::new(move |f| Rc::new(move |x| apply(m.clone(), apply(n.clone(), f.clone()))))
}

// Step 6: Implement Pairs

fn lc_pair(x: Expr, y: Expr) -> Expr {
    Rc::new(move |f| apply(apply(f, x.clone()), y.clone()))
}

fn lc_first(p: Expr) -> Expr {
    apply(
        p,
        Rc::new(|x| Rc::new(move |y| x(Rc::new(identity)))),
    )
}

fn lc_second(p: Expr) -> Expr {
    apply(
        p,
        Rc::new(|x| Rc::new(move |y| y(Rc::new(identity)))),
    )
}

// Step 7: Build Lists Using Pairs

fn lc_nil() -> Expr {
    lc_pair(lc_true(), lc_true())
}

fn lc_cons(head: Expr, tail: Expr) -> Expr {
    lc_pair(lc_false(), lc_pair(head, tail))
}

fn lc_is_nil(list: Expr) -> Expr {
    lc_first(list)
}

fn lc_head(list: Expr) -> Expr {
    lc_first(lc_second(list))
}

fn lc_tail(list: Expr) -> Expr {
    lc_second(lc_second(list))
}

// Step 8: Implement Comparison Operations

fn lc_is_zero(n: Expr) -> Expr {
    apply(n, Rc::new(|_| lc_false()))
}

fn lc_leq(m: Expr, n: Expr) -> Expr {
    lc_is_zero(apply(
        apply(
            m,
            Rc::new(|x| lc_succ(x(Rc::new(identity)))),
        ),
        n,
    ))
}

fn lc_eq(m: Expr, n: Expr) -> Expr {
    lc_and(lc_leq(m.clone(), n.clone()), lc_leq(n, m))
}

// Helper function for lc_eq
fn lc_and(a: Expr, b: Expr) -> Expr {
    lc_if(a, b, lc_false())
}

// Step 9: Implement Higher-Order List Operations

fn lc_map(f: Expr, list: Expr) -> Expr {
    lc_if(
        lc_is_nil(list.clone()),
        lc_nil(),
        lc_cons(
            apply(f.clone(), lc_head(list.clone())),
            lc_map(f, lc_tail(list)),
        ),
    )
}

fn lc_filter(pred: Expr, list: Expr) -> Expr {
    lc_if(
        lc_is_nil(list.clone()),
        lc_nil(),
        lc_if(
            apply(pred.clone(), lc_head(list.clone())),
            lc_cons(
                lc_head(list.clone()),
                lc_filter(pred.clone(), lc_tail(list.clone())),
            ),
            lc_filter(pred, lc_tail(list)),
        ),
    )
}

fn lc_fold(f: Expr, acc: Expr, list: Expr) -> Expr {
    lc_if(
        lc_is_nil(list.clone()),
        acc,
        lc_fold(
            f.clone(),
            apply(apply(f, acc), lc_head(list.clone())),
            lc_tail(list),
        ),
    )
}

// Step 10: Explore Recursion and Fixed-Point Combinators

fn y_combinator() -> Expr {
    Rc::new(|f| {
        apply(
            Rc::new(move |x| apply(f.clone(), apply(x.clone(), x))),
            Rc::new(move |x| apply(f.clone(), apply(x.clone(), x))),
        )
    })
}

fn lc_factorial() -> Expr {
    apply(
        y_combinator(),
        Rc::new(|f| {
            Rc::new(move |n| {
                lc_if(
                    lc_is_zero(n.clone()),
                    lc_succ(lc_zero()),
                    lc_mult(n.clone(), apply(f, lc_pred(n))),
                )
            })
        }),
    )
}

// Helper function for lc_factorial
fn lc_pred(n: Expr) -> Expr {
    lc_second(apply(
        apply(
            n,
            Rc::new(|p| {
                lc_pair(lc_second(p.clone()), lc_succ(lc_second(p)))
            }),
        ),
        lc_pair(lc_zero(), lc_zero()),
    ))
}

fn main() {
    // Example usage
    let one = lc_succ(lc_zero());
    let two = lc_succ(one.clone());
    let three = lc_add(one.clone(), two.clone());

    println!("1 + 2 = {}", church_to_int(three));

    let fact_5 = apply(lc_factorial(), lc_succ(lc_succ(lc_succ(lc_succ(lc_succ(lc_zero()))))));
    println!("5! = {}", church_to_int(fact_5));
}