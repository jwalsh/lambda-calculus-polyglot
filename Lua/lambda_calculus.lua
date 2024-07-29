--[[
File: lambda_calculus.lua
Author: Claude (Anthropic AI model)
Date: 2024-07-29
Description: Lambda Calculus implementation in Lua
Usage: Run with `lua lambda_calculus.lua`
]]

-- Step 1: Understand Lambda Expressions

-- Identity function
local function identity(x)
    return x
end

-- Apply a lambda expression to an argument
local function apply(f, x)
    return f(x)
end

-- Step 2: Implement Church Booleans

local function lc_true(x, y)
    return x
end

local function lc_false(x, y)
    return y
end

local function lc_if(condition, then_clause, else_clause)
    return condition(then_clause, else_clause)
end

-- Step 3: Implement Basic Combinators

local function i_combinator(x)
    return x
end

local function k_combinator(x)
    return function(y)
        return x
    end
end

local function ki_combinator(x)
    return function(y)
        return y
    end
end

-- Step 4: Create Church Numerals

local function lc_zero(f)
    return function(x)
        return x
    end
end

local function lc_succ(n)
    return function(f)
        return function(x)
            return f(n(f)(x))
        end
    end
end

local function church_to_int(n)
    return n(function(x) return x + 1 end)(0)
end

-- Step 5: Implement Basic Arithmetic

local function lc_add(m, n)
    return function(f)
        return function(x)
            return m(f)(n(f)(x))
        end
    end
end

local function lc_mult(m, n)
    return function(f)
        return m(n(f))
    end
end

local lc_one = lc_succ(lc_zero)
local lc_two = lc_succ(lc_one)

-- Step 6: Implement Pairs

local function lc_pair(x, y)
    return function(f)
        return f(x, y)
    end
end

local function lc_first(p)
    return p(function(x, y) return x end)
end

local function lc_second(p)
    return p(function(x, y) return y end)
end

-- Step 7: Build Lists Using Pairs

local function lc_nil()
    return lc_pair(lc_true, lc_true)
end

local function lc_cons(head, tail)
    return lc_pair(lc_false, lc_pair(head, tail))
end

local function lc_is_nil(list)
    return lc_first(list)
end

local function lc_head(list)
    return lc_first(lc_second(list))
end

local function lc_tail(list)
    return lc_second(lc_second(list))
end

-- Step 8: Implement Comparison Operations

local function lc_is_zero(n)
    return n(function(_) return lc_false end)(lc_true)
end

local function lc_leq(m, n)
    return lc_is_zero(lc_sub(m, n))
end

local function lc_eq(m, n)
    return lc_and(lc_leq(m, n), lc_leq(n, m))
end

-- Helper functions for Step 8
local function lc_sub(m, n)
    return n(lc_pred)(m)
end

local function lc_pred(n)
    return function(f)
        return function(x)
            return n(function(g)
                return function(h)
                    return h(g(f))
                end
            end)(function(_) return x end)(function(u) return u end)
        end
    end
end

local function lc_and(a, b)
    return lc_if(a, b, lc_false)
end

-- Step 9: Implement Higher-Order List Operations

local function lc_map(f, list)
    return lc_if(lc_is_nil(list),
        lc_nil,
        function() return lc_cons(f(lc_head(list)), lc_map(f, lc_tail(list))) end)
end

local function lc_filter(pred, list)
    return lc_if(lc_is_nil(list),
        lc_nil,
        function()
            return lc_if(pred(lc_head(list)),
                function() return lc_cons(lc_head(list), lc_filter(pred, lc_tail(list))) end,
                function() return lc_filter(pred, lc_tail(list)) end)
        end)
end

local function lc_fold(f, acc, list)
    return lc_if(lc_is_nil(list),
        acc,
        function() return lc_fold(f, f(acc, lc_head(list)), lc_tail(list)) end)
end

-- Step 10: Explore Recursion and Fixed-Point Combinators

local function y_combinator(f)
    local g = function(x)
        return f(function(y)
            return x(x)(y)
        end)
    end
    return g(g)
end

local lc_factorial = y_combinator(function(f)
    return function(n)
        return lc_if(lc_is_zero(n),
            lc_one,
            function() return lc_mult(n, f(lc_pred(n))) end)
    end
end)

-- Example usage
local three = lc_add(lc_one, lc_two)
print("1 + 2 =", church_to_int(three))

local fact_5 = church_to_int(lc_factorial(lc_succ(lc_succ(lc_succ(lc_succ(lc_one))))))
print("5! =", fact_5)