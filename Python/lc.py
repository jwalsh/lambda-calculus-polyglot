# CORE LAMBDA CALCULUS

# Combinators (Fundamental Functions)
lc_identity = lambda x: x
lc_kestrel = lambda x: lambda y: x
lc_kite = lambda x: lambda y: y
lc_bluebird = lambda x: lambda y: lambda z: x(y(z))

# Fundamental Selector (Building Block)
lc_select = lambda x: lambda y: lambda selector: selector(x)(y)

# Pairs, First, and Rest (Building upon the Selector)
lc_pair = lambda x: lambda y: lambda f: f(x)(y)
lc_first = lambda p: p(lc_true)
lc_second = lambda p: p(lc_false)
lc_nil = lambda x: lc_true
lc_cons = lc_pair
lc_is_nil = lambda l: l(lambda h: lambda t: lc_false)

# Booleans and Logic (Building upon Pairs and the Selector)
lc_true = lambda x: lambda y: x
lc_false = lambda x: lambda y: y
lc_if = lambda c: lambda t: lambda e: c(t)(e)
lc_and = lambda x: lambda y: x(y)(lc_false)
lc_or = lambda x: lambda y: x(lc_true)(y)
lc_not = lambda x: x(lc_false)(lc_true)
lc_xor = lambda x: lambda y: x(lc_not(y))(y)

# Church Numerals and Arithmetic (Building upon Pairs and Booleans)
lc_zero = lambda f: lambda x: x
lc_inc = lambda n: lambda f: lambda x: f(n(f)(x))
lc_add = lambda m: lambda n: lambda f: lambda x: m(f)(n(f)(x))
lc_sub = lambda m: lambda n: n(lc_dec)(m)
lc_mul = lambda m: lambda n: lambda f: lambda x: m(n(f))(x)
lc_pow = lambda m: lambda n: n(m)
lc_dec = lambda n: lambda f: lambda x: n(lambda g: lambda h: h(g(f)))(lambda u: x)(lambda u: u)
lc_is_zero = lambda n: n(lambda x: lc_false)(lc_true)

# Comparison Operations
lc_equal = lambda m: lambda n: lc_and(lc_is_zero(lc_sub(m)(n)))(lc_is_zero(lc_sub(n)(m)))
lc_less_than = lambda m: lambda n: lc_not(lc_is_zero(lc_sub(n)(m)))
lc_greater_than = lambda m: lambda n: lc_less_than(n)(m)
lc_less_than_or_equal = lambda m: lambda n: lc_or(lc_less_than(m)(n))(lc_equal(m)(n))
lc_greater_than_or_equal = lambda m: lambda n: lc_or(lc_greater_than(m)(n))(lc_equal(m)(n))

# Additional Arithmetic Operations
lc_div = lambda m: lambda n: lc_if(lc_is_zero(n))(
    lc_zero
)(
    lc_if(lc_less_than(m)(n))(
        lc_zero
    )(
        lc_inc(lc_div(lc_sub(m)(n))(n))
    )
)

lc_mod = lambda m: lambda n: lc_if(lc_is_zero(n))(
    lc_zero
)(
    lc_if(lc_less_than(m)(n))(
        m
    )(
        lc_mod(lc_sub(m)(n))(n)
    )
)

lc_abs = lambda n: lc_if(lc_less_than(n)(lc_zero))(lc_sub(lc_zero)(n))(n)
lc_max = lambda m: lambda n: lc_if(lc_less_than(m)(n))(n)(m)
lc_min = lambda m: lambda n: lc_if(lc_less_than(m)(n))(m)(n)

# Characters (A-Z)
lc_char_A = lambda x: x
lc_char_B = lambda x: x(lc_char_A)
lc_char_C = lambda x: x(lc_char_B)
# ... (similarly for D through Y)
lc_char_Z = lambda x: x(lc_char_Y)

# DATA STRUCTURES

# Lists and Vectors
lc_list = lambda x: lambda xs: lc_cons(x)(xs)
lc_list_empty = lc_nil

lc_list_length = lambda l: lc_if(lc_is_nil(l))(lc_zero)(lc_inc(lc_list_length(lc_second(l))))

lc_list_append = lambda l1: lambda l2: lc_if(lc_is_nil(l1))(
    l2
)(
    lc_cons(lc_first(l1))(lc_list_append(lc_second(l1))(l2))
)

lc_list_map = lambda f: lambda l: lc_if(lc_is_nil(l))(
    lc_nil
)(
    lc_cons(f(lc_first(l)))(lc_list_map(f)(lc_second(l)))
)

lc_list_filter = lambda pred: lambda l: lc_if(lc_is_nil(l))(
    lc_nil
)(
    lc_if(pred(lc_first(l)))(
        lc_cons(lc_first(l))(lc_list_filter(pred)(lc_second(l)))
    )(
        lc_list_filter(pred)(lc_second(l))
    )
)

lc_list_foldl = lambda f: lambda acc: lambda l: lc_if(lc_is_nil(l))(
    acc
)(
    lc_list_foldl(f)(f(acc)(lc_first(l)))(lc_second(l))
)

lc_list_foldr = lambda f: lambda acc: lambda l: lc_if(lc_is_nil(l))(
    acc
)(
    f(lc_first(l))(lc_list_foldr(f)(acc)(lc_second(l)))
)

lc_list_reverse = lambda l: lc_list_foldl(lambda acc: lambda x: lc_cons(x)(acc))(lc_nil)(l)

lc_list_at = lambda l: lambda n: lc_if(lc_is_zero(n))(
    lc_first(l)
)(
    lc_list_at(lc_second(l))(lc_dec(n))
)

lc_list_slice = lambda l: lambda start: lambda end: lc_list_take(lc_list_drop(l)(start))(lc_sub(end)(start))

lc_list_take = lambda l: lambda n: lc_if(lc_or(lc_is_nil(l))(lc_is_zero(n)))(
    lc_nil
)(
    lc_cons(lc_first(l))(lc_list_take(lc_second(l))(lc_dec(n)))
)

lc_list_drop = lambda l: lambda n: lc_if(lc_or(lc_is_nil(l))(lc_is_zero(n)))(
    l
)(
    lc_list_drop(lc_second(l))(lc_dec(n))
)

# Trees
lc_tree_empty = lc_nil
lc_tree_make = lambda value: lambda left: lambda right: lc_list(value)(left)(right)
lc_tree_value = lambda t: lc_first(t)
lc_tree_left = lambda t: lc_second(t)
lc_tree_right = lambda t: lc_second(lc_second(t))
lc_tree_is_empty = lc_is_nil

# Graphs (Adjacency Lists Representation)
lc_graph_empty = lc_nil
lc_graph_add_vertex = lambda g: lambda vertex: lc_cons(lc_pair(vertex)(lc_nil))(g)
lc_graph_add_edge = lambda g: lambda v1: lambda v2: lc_if(lc_is_nil(g))(
    lc_graph_empty
)(
    lc_cons(
        lc_if(lc_equal(v1)(lc_first(lc_first(g))))(
            lc_pair(lc_first(lc_first(g)))(lc_cons(v2)(lc_second(lc_first(g))))
        )(
            lc_first(g)
        )
    )(
        lc_graph_add_edge(lc_second(g))(v1)(v2)
    )
)

# Dictionaries
lc_dict_empty = lambda k: lc_false
lc_dict_insert = lambda d: lambda k: lambda v: lambda k_: lc_if(lc_equal(k)(k_))(v)(d(k_))
lc_dict_lookup = lambda d: lambda k: d(k)
lc_dict_update = lambda d: lambda k: lambda v: lc_dict_insert(d)(k)(v)
lc_dict_remove = lambda d: lambda k: lambda k_: lc_if(lc_equal(k)(k_))(lc_false)(d(k_))

# Sets (Using Dictionaries)
lc_set_empty = lc_dict_empty
lc_set_insert = lc_dict_insert
lc_set_member = lambda s: lambda x: lc_not(lc_is_nil(s(x)))
lc_set_remove = lc_dict_remove
lc_set_union = lambda s1: lambda s2: lambda x: lc_or(s1(x))(s2(x))
lc_set_intersection = lambda s1: lambda s2: lambda x: lc_and(s1(x))(s2(x))
lc_set_difference = lambda s1: lambda s2: lambda x: lc_and(s1(x))(lc_not(s2(x)))
lc_set_equal = lambda s1: lambda s2: lc_and(lc_set_subset(s1)(s2))(lc_set_subset(s2)(s1))
lc_set_subset = lambda s1: lambda s2: lc_list_foldl(lambda acc: lambda x: lc_and(acc)(s2(x)))(lc_true)(s1)

# Optional type (Maybe monad)
lc_maybe_some = lambda x: lc_pair(lc_true)(x)
lc_maybe_none = lc_pair(lc_false)(lc_nil)
lc_maybe_is_some = lambda m: lc_first(m)
lc_maybe_is_none = lambda m: lc_not(lc_maybe_is_some(m))
lc_maybe_map = lambda f: lambda m: lc_if(lc_maybe_is_some(m))(
    lc_maybe_some(f(lc_second(m)))
)(
    lc_maybe_none
)

# Identity and Combinators
lc_i = lambda x: x  # Identity combinator
lc_k = lambda x: lambda y: x  # Constant combinator
lc_ki = lambda x: lambda y: y  # Kestrel combinator (flipped K)
lc_s = lambda x: lambda y: lambda z: x(z)(y(z))  # S combinator
lc_b = lambda x: lambda y: lambda z: x(y(z))  # B combinator
lc_c = lambda x: lambda y: lambda z: x(z)(y)  # C combinator
