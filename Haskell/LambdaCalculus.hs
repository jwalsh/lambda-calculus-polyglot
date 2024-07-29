{-
Model: Claude 3.5 Sonnet (July 2024)
Author: Anthropic, PBC

Filename: LambdaCalculus.hs
Usage: Load this file into GHCi (Glasgow Haskell Compiler interactive environment) 
       by running `ghci LambdaCalculus.hs` in your terminal.
       Then you can interact with the defined functions and test the implementation.
-}

module LambdaCalculus where

-- Step 1: Understand Lambda Expressions
-- In Haskell, we can use anonymous functions for lambda expressions
identity :: a -> a
identity = \x -> x

-- Step 2: Implement Church Booleans
type LCBool = forall a. a -> a -> a

lcTrue :: LCBool
lcTrue = \x _ -> x

lcFalse :: LCBool
lcFalse = \_ y -> y

lcIf :: LCBool -> a -> a -> a
lcIf condition thenCase elseCase = condition thenCase elseCase

-- Step 3: Implement Basic Combinators
i :: a -> a
i = \x -> x

k :: a -> b -> a
k = \x _ -> x

ki :: a -> b -> b
ki = \_ y -> y

-- Step 4: Create Church Numerals
type LCNat = forall a. (a -> a) -> a -> a

lcZero :: LCNat
lcZero = \_ x -> x

lcSucc :: LCNat -> LCNat
lcSucc n = \f x -> f (n f x)

churchToInt :: LCNat -> Int
churchToInt n = n (+1) 0

intToChurch :: Int -> LCNat
intToChurch 0 = lcZero
intToChurch n = lcSucc (intToChurch (n - 1))

-- Step 5: Implement Basic Arithmetic
lcAdd :: LCNat -> LCNat -> LCNat
lcAdd m n = \f x -> m f (n f x)

lcMult :: LCNat -> LCNat -> LCNat
lcMult m n = \f -> m (n f)

-- Step 6: Implement Pairs
type LCPair a b = forall c. (a -> b -> c) -> c

lcPair :: a -> b -> LCPair a b
lcPair x y = \f -> f x y

lcFirst :: LCPair a b -> a
lcFirst p = p (\x _ -> x)

lcSecond :: LCPair a b -> b
lcSecond p = p (\_ y -> y)

-- Step 7: Build Lists Using Pairs
type LCList a = forall b. (a -> b -> b) -> b -> b

lcNil :: LCList a
lcNil = \_ n -> n

lcCons :: a -> LCList a -> LCList a
lcCons x xs = \c n -> c x (xs c n)

lcIsNil :: LCList a -> LCBool
lcIsNil xs = xs (\_ _ -> lcFalse) lcTrue

lcHead :: LCList a -> a
lcHead xs = xs (\x _ -> x) (error "Empty list")

lcTail :: LCList a -> LCList a
lcTail xs = lcSecond (xs (\x r -> lcPair x (lcFirst r)) (lcPair (error "Empty list") lcNil))

-- Step 8: Implement Comparison Operations
lcIsZero :: LCNat -> LCBool
lcIsZero n = n (\_ -> lcFalse) lcTrue

lcLessThan :: LCNat -> LCNat -> LCBool
lcLessThan m n = lcIsZero (lcSubtract m n)

lcEqual :: LCNat -> LCNat -> LCBool
lcEqual m n = lcAnd (lcLessThan m (lcSucc n)) (lcLessThan n (lcSucc m))

-- Helper functions for comparison
lcSubtract :: LCNat -> LCNat -> LCNat
lcSubtract m n = n lcPred m
  where
    lcPred :: LCNat -> LCNat
    lcPred n = lcFirst (n (\p -> lcPair (lcSecond p) (lcSucc (lcSecond p))) (lcPair lcZero lcZero))

lcAnd :: LCBool -> LCBool -> LCBool
lcAnd p q = p q lcFalse

-- Step 9: Implement Higher-Order List Operations
lcMap :: (a -> b) -> LCList a -> LCList b
lcMap f xs = xs (\x r -> lcCons (f x) r) lcNil

lcFilter :: (a -> LCBool) -> LCList a -> LCList a
lcFilter p xs = xs (\x r -> lcIf (p x) (lcCons x r) r) lcNil

lcFold :: (a -> b -> b) -> b -> LCList a -> b
lcFold f z xs = xs f z

-- Step 10: Explore Recursion and Fixed-Point Combinators
fix :: (a -> a) -> a
fix f = let x = f x in x

-- Example: Factorial using fix
lcFactorial :: LCNat -> LCNat
lcFactorial = fix $ \f n ->
  lcIf (lcIsZero n)
       (intToChurch 1)
       (lcMult n (f (lcSubtract n (intToChurch 1))))

-- Helper function to convert LCList of LCNat to regular Haskell list of Int
lcListToList :: LCList LCNat -> [Int]
lcListToList xs = lcFold (\x acc -> churchToInt x : acc) [] xs

-- Example usage
main :: IO ()
main = do
  putStrLn "Church numeral examples:"
  print $ churchToInt (lcSucc lcZero)  -- Should output 1
  print $ churchToInt (lcAdd (intToChurch 2) (intToChurch 3))  -- Should output 5
  print $ churchToInt (lcMult (intToChurch 2) (intToChurch 3))  -- Should output 6

  putStrLn "\nChurch boolean examples:"
  print $ lcIf lcTrue "yes" "no"  -- Should output "yes"
  print $ lcIf lcFalse "yes" "no"  -- Should output "no"

  putStrLn "\nList examples:"
  let list123 = lcCons (intToChurch 1) (lcCons (intToChurch 2) (lcCons (intToChurch 3) lcNil))
  print $ lcListToList list123  -- Should output [1,2,3]
  print $ lcListToList (lcMap (lcAdd (intToChurch 1)) list123)  -- Should output [2,3,4]
  print $ lcListToList (lcFilter (\n -> lcLessThan n (intToChurch 3)) list123)  -- Should output [1,2]

  putStrLn "\nFactorial example:"
  print $ churchToInt (lcFactorial (intToChurch 5))  -- Should output 120