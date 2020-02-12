-- %% markdown
-- # Chapter 3 -- Types and Typeclasses
--

-- %%
-- IHaskell settings
:opt no-lint
:opt no-pager


-- %% markdown
-- ## Haskell type system:
-- - the type of _every_ expression is known at compile time
-- - has type inference: cleaner type annotations
-- - Types are always wrote with capital case
-- - To examine types, use `:t` command
-- %%
:t 'a'
:t True
:t "Hello types !" -- `[]` denotes a list
:t (True, 'a')
:t 4 == 5

-- %% markdown
-- Functions have types:
--
-- An Haskell programmer can choose to give a function an explicit type declation -- generally this is considered to be good practice except when writing very short functions

-- %%
removeNonUppercase :: [Char] -> [Char] -- IHaskell doesn't need `let` for functions to have type declation
removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]

-- %% markdown
-- Haskell can infer function type without type declation
-- %%
removeNonUppercase' st = [ c | c <- st, c `elem` ['A'..'Z']]
:t removeNonUppercase'

-- %% markdown
-- Type declation for function with several parameters:
-- - there is no special distinction between the parameters and the return type
-- %%
addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z
addThree 1 2 3


-- %% markdown
-- ## Common types

-- %% markdown
-- `Int`:
-- - on 32-bit machine: `-2^31+1` ~ `2^31-1`
-- - on 64-bit machine: `-2^63+1` ~ `2^63-1`
-- `Integer`: not bounded but less efficient
-- %%
show (maxBound :: Int)
2^63 - 1
-- show (maxBound :: Integer) -- Will result in error !

-- %%
factorial :: Int -> Int
factorial n = product [1..n]
factorial 50 -- `Int` overflows !
-- %%
factorial' :: Integer -> Integer
factorial' n = product [1..n]
factorial' 50 -- `Integer` doesn't overflows !

-- %% markdown
-- - `Float`: a real floating point with single precision
-- - `Double`: a real floating point with double the precision
-- %%
circumference :: Float -> Float
circumference r = 2 * pi * r
circumference 4.0
-- %%
circumference' :: Double -> Double
circumference' r = 2 * pi * r
circumference' 4.0

-- %% markdown
-- `Bool`: has only two values -- `True` and `False`

-- %% markdown
-- - `Char`: denoted by single quotes
-- - `[Char]`(`String`): denoted by double quotes
-- %%
:t 'a'
:t "a"

-- %% markdown
-- Tuple types:
-- - varies by their length and the type of their components: there are theoretically infinite number of tuple types
-- - empty tuple has a type -- and the type only has a single value `()`
-- %%
:t (1, '1')
:t ()


-- %% markdown
-- ## Type variables

-- %%
:t head
:t fst

-- %% markdown
-- `a` and `b` are **type variable**s
-- - it's not written in capital case so it's not exactly a type.
-- - is much like generics in class-based OOP, but much more powerful than that
-- - lets us to write very general functions if they don't use any specific behaviour of the types in them
--   * functions that have type variables are called ***polymorphic functions***


-- %% markdown
-- ## Typeclass
-- - is a sort of _interface_ that defines some behaviour
--   * if a type s a part of a typeclass, that means that it supports and implements the behavior the typeclass describes

-- %%
:t (==)
-- NOTE:
-- for infix functions, we need to surround it in parentheses in order to
-- examine its type, pass it to another function or call it as a prefix function
-- e.g. `(==) 1 1`

-- %% markdown
-- `=>` symbol:
-- - everything before `=>` is called **class constraint**
-- - means `a` must be a member of the `Eq` class
--
-- `Eq` typeclass provides and interface for testing for equality
-- - Any type where it makes sense to test for equality between two values of that type should be a member of the `Eq` class

-- %% markdown
-- ### Basic typeclasses

-- %% markdown
-- **`Eq`**:
-- - is used for types that support equality testing
-- - its members need to implement `==` and `/=`
--   * if there is an `Eq` typeclass constraint for a variable in a function, then it uses `==` or `/=` somewhere inside its definition
-- - All standard Haskell types except for IO (the type for dealing with input and output) and functions are a part of the `Eq` typeclass

-- %% markdown
-- **`Ord`**:
-- - is for types that have an ordering
-- - covers all the standard comparing functions such as `>`, `<`, `>=` and `<=`
-- - the `compare` function takes two `Ord` members of the same type and returns an ordering:
-- - `Ordering` is a type that represent the "ordering":
--   * it can be `GT`, `LT` or `EQ`, meaning _greater than_, _lesser than_ and _equal_, respectively
-- %%
:t (>)
"Abrakadabra" `compare` "Zebra"
5 `compare` 3

-- %% markdown
-- **`Show`**:
-- - its member can be presented as a string
-- - the most used function that deals with the `Show` typeclass is `show` -- it takes a value whose type is a member of `Show` and presents it to us as a string
-- %%
show 3
:t show True

-- %% markdown
-- **`Read`**:
-- - opposite typeclass of `Show` -- the `read` function takes a srring and returns a type which is a member of `Read`
-- %%
read "True" || False
read "8.2" + 3.8
read (show 5) - 2
read "[1,2,3,4]" ++ [3]
-- %% markdown
-- NOTE:
-- - all the usages of `read` so far is where their result is used afterwards -- thus Haskell can infer the return type of `read`
-- - but just `read "1"` won't work, since Haskell doesn't know which type in `Read` typeclass we want.
-- %%
read "1" -- Error !
-- %%
:t read -- the return type is a type variable !

-- %% markdown
-- We can use explicit **type annotations** for saying what the type of an expression should be. For type annotations, we use `::`
-- %%
read "1" :: Int -- No error !
read "1" :: Float
:t (read "1" :: Float) * 4
read "(1, '1')" :: (Int, Char)

-- %% markdown
-- Where to use type annotation:
-- > Most expressions are such that the compiler can infer what their type is by itself.
-- > But sometimes, the compiler doesn't know whether to return a value of type `Int` or `Float` for an expression like `read "5"`.
-- > To see what the type is, Haskell would have to actually evaluate `read "5"`.
-- > **But since Haskell is a statically typed language, it has to know all the types before the code is compiled** (or in the case of GHCI, evaluated).
-- > So we have to tell Haskell: "Hey, this expression should have this type, in case you don't know!".

-- %% markdown
-- **`Enum`**:
-- - its members are sequentially ordered types -- they can be _enumerated_
-- - use cases:
--   * list ranges
--   * successor and predecesor: `succ` and `pred`
-- - types in this classes: `()`, `Bool`, `Char`, `Ordering`, `Int`, `Integer`, `Float`, `Double`
-- %%
[LT .. GT]
succ 'B'
pred True
-- pred False -- will result in error

-- %% markdown
-- **`Bounded`** members have an upper and a lower bound
-- %%
-- XXX: in IHaskell, the result of `maxBound :: T` is needed to be used in some way
show (minBound :: Int)
show (maxBound :: Char)

-- %% markdown
-- NOTE: all tuples are part of `Bounded` if the components are also in it.
-- %%
show (maxBound :: (Int, Char, Bool))

-- %% markdown
-- **`Num`** is a numeric typeclass -- its members have the property of being able to act like numbers.
--
-- To join `Num`, a type must already be friends with `Show` and `Eq`
--
-- Actually whole numbers are polymorphic constants -- they can act like any type that's a member of the `Num` typeclass.
-- %%
:t 20
20 :: Int
20 :: Integer
20 :: Float
20 :: Double

-- %%
:t (*)

-- %% markdown
-- `*` takes two numbers of **the same type** and returns a number of that type. So the behavior below.
-- %%
(5 :: Int) * (6 :: Integer) -- Error
-- %%
5 * (6 :: Integer) -- No error !

-- %% markdown
-- - `Num` includes all numbers, including real and integral
-- - `Integral` only includes integral (whole) numbers
--   * `Int` and `Integer` is in this typeclass
-- - `Floating` only includes floating point numbers
--   * `Float` and `Double` is in this typeclass

-- %% markdown
-- **`fromIntegral`**:
-- - `fromIntegral :: forall a b. (Integral a, Num b) => a -> b`
-- - useful when we want integral and floating point types to work together nicely
--
-- E.g. add a length of a list to a floating point
-- %%
(length [1, 2, 3]) + 3.2
-- %%
fromIntegral (length [1, 2, 3]) + 3.2
-- %%
:t length
-- %% markdown
-- NOTE:
-- - If `length` has a more general type `(Num b) => length :: [a] -> b`, then we don't need `fromIntegral` from the beginning
-- - but maybe there are historical reasons, huh
