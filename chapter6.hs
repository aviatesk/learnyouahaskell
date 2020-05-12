-- %% markdown
-- # Chapter 6 -- Higher Order Functions

-- %%
-- IHaskell settings
:opt no-lint
:opt no-pager

-- %% markdown
-- **Higher order function**: a function that does either of:
-- - take functions as parameters
-- - return functions as return value
--
-- > Higher order functions aren't just a part of the Haskell experience, they pretty much are _the Haskell experience_.
-- > It turns out that if you want to define computations by defining what stuff _is_ instead of defining steps that change some state and maybe looping them, higher order functions are indispensable.
-- > They're a really powerful way of solving problems and thinking about programs.


-- %% markdown
-- ## Curried Functions
--
-- ... Every function in Haskell officially only takes one parameter; so how is it possible that we defined and used several function that take more than one parameter so far ?
--
-- The clever trick: all the functions that accepted _several parameters_ so far have been **Curried Functions**
--
-- Example: `max 4 5`:
-- - first creates a function that takes a parameter and return either 4 or that parameter, depending on which is bigger
-- - then, `5` is applied to that function and that function produced our desired result
-- - ... sounds mouthful, but it's actually a really cool concept

-- %%
-- So the following two calls are equivalent
max 4 5
(max 4) 5
:t max
:t max 4

-- %% markdown
-- The space is sort of like an operator (function application) and it has the highest precedence; `max :: (Ord a) => a -> a -> a` can be written as `max :: (Ord a) => a -> (a -> a)`:
-- - read as `max` takes an `a` and returns (that's the `->`) a function that takes an `a` and returns an `a`
-- - this is why the return type and the parameters of functions are all simply separated with arrows
--
-- How beneficial ?:
-- - **partially applied function**: a function that takes as many parameters as we left out
-- - using partial application (i.e. calling functions with too few parameters, if we will) is a neat way to create functions on the fly so we can pass them to another function or to seed them with some data

-- %% markdown
-- Verbose explanation

-- %%
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

multThree 3 5 9
((multThree 3) 5) 9

-- %% markdown
-- `multThree 3 5 9` (or `((multThree 3) 5) 9`):
--
-- 1. first, `3` is applied to `multThree`, because they're separated by a space; that creates a function that takes one parameter and returns a function
-- 2. then `5` is applied to that, which creates a function that will take a parameter and multiply it by `15`
-- 3. finally `9` is applied to that function and the result is `135` or something
--
-- Function type `multThree :: (Num a) => a -> (a -> (a -> a))`
-- (the thing before the `->` is the parameter that a function takes and the thing after it is what it returns):
--
-- 1. first, `multThree` takes an `a` and returns a function of type `(Num a) => a -> (a -> a)`
-- 2. then this function takes an `a` and returns function of type `(Num a) => a -> a`
-- 3. finally this function just takes an `a` and return an `a`

-- %%
let multTwoWithNine = multThree 9
multTwoWithNine 2 3
let multWithEighteen = multTwoWithNine 2
multWithEighteen 10

-- %%
compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred x = compare 100 x
compareWithHundred 99

compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred = compare 100 -- wow !
compareWithHundred 99

-- %% markdown
-- By calling functions with too few parameters, so to speak, we're creating new functions _on the fly_.

-- %% markdown
-- Infix functions can also be partially applied by using sections:
-- - to section an infix function, simply surround it with parentheses and only supply a parameter on one side
-- - that creates a function that takes one parameter and then applies it to the side that's missing an operand

-- %%
devideByTen :: (Floating a) => a -> a
devideByTen = (/10)

devideTen :: (Floating a) => a -> a
devideTen = (10/)

isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A'..'Z'])

devideTen 5
devideByTen 5
isUpperAlphanum 's'
isUpperAlphanum 'S'

-- %%
-- NOTE:
-- The only special thing about sections is using `-`;
-- for convenience, (-4) means minus four, not a partially applied function.
-- For that, we need partially apply the `subtract` function
subtractFour = subtract 4
subtractFour 10

-- %% markdown
-- NOTE: Functions aren't instances of the `Show` typeclass, so we can't get a neat string representation of a function; so the error below

-- %%
multThree 3 4


-- %% markdown
-- ## Higher-orderism
--
-- Functions can take functions as parameters and also return functions.

-- %%
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- %% markdown
-- Type declaration: `applyTwice :: (a -> a) -> a -> a`:
-- - the parentheses are mandatory: that indicates the first parameter is a function that takes something and returns the same thing
--   * NOTE: parentheses are right-associative
-- - let's read as:
--   * this function takes two parameters and returns one thing
--   * the first parameter is a function (of type `a -> a`)
--   * the second is that same `a`
--
-- Body itself is so simple; we can understand it well

-- %%
applyTwice (+3) 10
applyTwice (++ " HAHA") "HEY"
applyTwice ("HAHA " ++) "HEY"
applyTwice (multThree 2 2) 9
applyTwice (1:) [3] -- here we go !

-- %% markdown
-- `zipWith`: takes a function and two lists as parameters and then joins the two lists by applying the function between corresponding elements

-- %%
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _          = []
zipWith' _ _ []          = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

zipWith' (+) [1..4] [(-1),(-2)..(-4)]
zipWith' max [1..4] [(-1),(-2)..(-4)]
zipWith' (++) ["foo ", "bar ", "baz "] ["fighters", "hoppers", "aldrin"]
zipWith' (+) (replicate 5 2) [1..]
zipWith' (zipWith' (+)) [[1..3], [4..6], [7..9]] [[1..3], [4..6], [7..9]]

-- %% markdown
-- `flip`: takes a function and returns a function that is like our original function, only the first two arguments are flipped

-- %%
flip' :: (a -> b -> c) -> (b -> a -> c) -- the second parentheses aren't really necessary
flip' f = g
  where g x y = f y x

-- %% markdown
-- By taking advantage of the fact that functions are curried, we can defined it in an even more simpler manner:

-- %%
-- NOTE: when we call `flip' f` without the parameters `y` and `x`, it will return an `f` that takes those two parameters but calls them flipped.
flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y

flip' zip [1..5] "hello"
zipWith (flip' div) [2,2..] [10,8..2]


-- %% markdown
-- ## `map`s and `filter`s
--
-- > Mapping and filtering is the bread and butter of every functional programmer's toolbox.

-- %% markdown
-- `map`: one of those really versatile higher-order functions that can be used in millions of different ways

-- %%
map' :: (a -> b) -> [a] -> [b]
map' _ []     = []
map' f (x:xs) = f x : map f xs

map' (+3) [1,5,3,1,6]
map' (++ "!") ["BIFF", "BANG", "POW"]
map' (replicate 3) [3..6]
map' (map' (^2)) [[1,2], [3..6], [7,8]]
map' fst [(1,2), (3,4), (5,6)]

-- %% markdown
-- `filter`

-- %%
filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
  | p x       = x : filter' p xs
  | otherwise = filter' p xs

filter' (>3) [1..10]
filter' (==3) [1..5]
filter' even [1..10]
let notNull x = not (null x) in filter notNull [[1..3], [], [4..6], [2,2], [], []]
filter (`elem` ['a'..'z']) "u LaUgH aT mE BeCaUsE I aM diFfeRent"
filter (`elem` ['A'..'Z']) "i lauGh At You BecAuse u r aLL the Same"

-- %% markdown
-- NOTE: the same thing could be achieved with a list comprehension:
-- - there's no set rule for when to use `map` and `filter` versus using list comprehension; we just have to decide what's more readable depending on the code and the context

-- %%
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  smallerSorted ++ [x] ++ biggerSorted
  where smallerSorted = quicksort (filter (<=x) xs)
        biggerSorted  = quicksort (filter (>x) xs)

quicksort "Shuhei Kadowaki"

-- %% markdown
-- Haskell laziness & `map`/`filter`:
-- > Thanks to Haskell's laziness, even if you map something over a list several times and filter it several times, it will only pass over the list once.

-- %% markdown
-- **find the largest number under 100,000 that's divisible by 3829**

-- %%
largestDivisible :: (Integral a) => a
largestDivisible = head (filter p [100000,99999..]) -- this can be infinite list; the computation stops anyways
  where p x = x `mod` 3829 == 0

-- %% markdown
-- **find the sum of all odd squares that are smaller than 10,000**
--
-- `takeWhile`:
-- - takes a predicate and a list and then goes from the beginning of the list and returns its elements while the predicate holds true; once an element is found for which the predicate doesn't hold, it stops

-- %%
-- awesome !
sum (takeWhile (<10000) (filter odd (map (^2) [1..])))

-- or using list comprehension (imho less readable)
sum (takeWhile (<10000) [ m | m <- [ n^2 | n <- [1..] ], odd m])

-- %% markdown
-- What makes this possible ? Haskell's property of laziness !:
-- - we can `map` over and `filter` an infinite list, because it won't actually `map` and `filter` it right away; it will delay those actions
-- - only when we force Haskell to show us the sum, the `sum` function say to the `takeWhile` that it needs those numbers
-- - `takeWhile` forces the `filter`ing and `map`ping to occur, but only until a number greater than or equal to 10,000 is encountered

-- %% markdown
-- **for all starting numbers between 1 and 100, how many Collatz chains have a length greater than 15 ?**
--
-- NOTE: Collatz chain always finishes at the number 1, for all starting numbers

-- %%
chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
  | even n = n : chain (n `div` 2)
  | odd n  = n : chain (n * 3 + 1)

chain 10

length (filter (>15) (map length (map chain [1..100])))

-- %% markdown
-- more higher-order function: `map (*) [0..]`
-- - c.f.: so far, we've only mapped functions that take one parameter over lists: e.g.: `map (*2) [0..]`
-- - what happens here: the number in the list is applied to the function `*`, which has a type of `(Num a) => a -> a -> a`
--   * applying only one parameter to a function that takes two parameters returns a partially applied function, which takes one parameter
--   * so we get back _a list of functions_ that only take one parameter, so `(Num a) => [a -> a]`
--     + `map (*) [0..]` produces a list like `[(*0), (*1), ...]`

-- %%
let listOfFuns = map (*) [0..] in (listOfFuns !! 5) 2


-- %% markdown
-- ## Lambdas
--
-- Lambdas: anonymous functions that are used because we need some functions only once; normally passed into a higher-order function

-- %%
-- syntax: `(\args -> body)`
zipWith (\a b -> (a * 30 + 3) / b) [5,4..1] [1..5]

-- caveat: don't abuse lambdas; using partial functions can lead to more readable code
map (+1) [0..9]
map (\x -> x + 1) [0..9]

-- pattern match: cant defined fall back definition !
map (\(a,b) -> a + b) [(1,2),(3,5),(6,3),(2,6)]

-- -- without parentheses, they extend all the way to the right
addThree :: (Num a) => a -> a -> a -> a
addThree x y z = x + y + z

-- addThree :: (Num a) => a -> a -> a -> a
-- addThree = \x -> \y -> \z -> x + y + z

-- more "sensible" `flip'` definition: it would be clearer that `flip'` is used for producing a new function most of the time
flip' :: (a -> b -> c) -> b -> a -> c
flip' f = \x y -> f y x

flip' (++) "kadowaki" "shuhei"


-- %% markdown
-- ## `fold`s
--
-- `fold` encapsulate the common pattern of the recursive functions on lists:
-- - have an edge case for the empty list
-- - introduce `x:xs` pattern and then do some action that involves a signle element and the rest of the list
--
-- > Folds can be used to implement any function where you traverse a list once, element by element, and then return something based on that. Whenever you want to traverse a list to return something, chances are you want a `fold`.

-- %% markdown
-- `foldl f acc xs`
-- - `f acc x`: binary function: produces a new accumulator from the current accumulator `acc` and the current list head `x`
-- - `acc`: a starting value, a.k.a. accumulator
-- - `list`: list to fold up

-- %%
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc + x) 0 xs

sum' [1..10]

-- %%
-- even more succinctly
sum' :: (Num a) => [a] -> a
sum' = foldl (+) 0 -- carrying !

sum' [1..10]

-- %%
elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldl (\acc x -> if x == y then True else acc) False ys

elem' 1 [0..10]
-- elem' 1 [0..] -- TODO

-- %% markdown
-- `foldr f acc xs`
-- - `f x acc`: binary function: produces a new accumulator from the current accumulator `acc` and the current list head `x`
-- - `acc`: a starting value, a.k.a. accumulator
-- - `list`: list to fold up

-- %%
map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs
-- map' f xs = foldl (\acc x -> acc ++ [f x]) [] xs -- NOTE: `++` is much more expensive than `:`

map' (+1) [0..9]

-- %% markdown
-- big difference:
-- - `foldr` can work on infinite lists, i.e. take an infinite list _at some point_ should work with `foldr`
-- - `foldl` can't on infinite lists

-- %% markdown
-- `foldl1`, `foldr1`:
-- - don't require an explicit starting value
-- - can be used when a function doesn't make sense given an empty list

-- %%
maximum' :: (Ord a) => [a] -> a
maximum' = foldr1 (\x acc -> if x > acc then x else acc)

reverse' :: [a] -> [a]
reverse' = foldl (\acc x -> x : acc) [] -- or `foldl (flip (:)) []`

product' :: (Num a) => [a] -> a
product' = foldr1 (*)

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x acc -> if p x then x : acc else acc) []

head' :: [a] -> a
head' = foldr1 (\x _ -> x)

last' :: [a] -> a
last' = foldr1 (\_ x -> x)

-- %% markdown
-- `scanl`, `scanr`, `scanl1`, `scanr1`: report all the intermediate accumulator states in the form of a list

-- %%
scanl (+) 0 [1..10]
scanr (+) 0 [1..10]
scanl1 (\acc x -> if x > acc then x else acc) [3,4,5,3,7,9,2,1]
scanl (flip (:)) [] [3,2..1]

-- %% markdown
-- **How many elements does it take for the sum of the roots of all natural numbers to exceed 1000 ?**

-- %%
sqrtSum = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..])))
sum (map sqrt [1..130])
sum (map sqrt [1..131])


-- %% markdown
-- ## Function application with `$`
--
-- ```haskell
-- ($) :: (a -> b) -> a -> b
-- f $ x = f x
-- ```
-- - normal function application (putting a space between two things): high precedence, left-associative
-- - `$` function: lowest precedence, right-associative
--
-- So, how this seemingly useless operator can be useful ?:
-- - we don't have to write so many parentheses !
--   * `sum (map sqrt [1..130])` ⟺ `sum $ map sqrt [1..130]`
--   * `sqrt (3 + 4 + 9)` ⟺ `sqrt $ 3 + 4 + 9`
--   * `sum (filter (>10) (map (*2) [2..10]))` ⟺ `sum $ filter (>10) $ map (*2) [2..10]`
-- - the function application can be treated just like another function
--   * e.g. map function application _over a list of functions_: `map ($ 3) [(4+), (10*), (^2), sqrt]`

-- %%
sum $ filter (>10) $ map (*2) [2..10]
map ($ 3) [(4+), (10*), (^2), sqrt]


-- %% markdown
-- ## Function composition
--
-- $(f \circ g)(x) = f(g(x))$:
-- ```haskell
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- f . g = \x -> f (g x)
-- ```
--
-- NOTE: function composition can make functions on the fly as lambdas do, but many times, is clearer and more concise

-- %%
map (\x -> negate (abs x)) [5,-3,-6,7,-3,2,-19,24]
map (negate . abs) [5,-3,-6,7,-3,2,-19,24]

-- %% markdown
-- Function composition is right-associative

-- %%
map (\xs -> negate (sum (tail xs))) [[1..5], [3..6], [1..7]]
map (negate . sum . tail) [[1..5], [3..6], [1..7]]

-- %% markdown
-- When functions take several parameters:
-- - we usually have to partially apply them just so much that each function takes just one parameter
--   * the expressions below are all equivalent:
--     + `sum (replicate 5 (max 6.7 8.9))`
--     + `(sum . replicate 5 . max 6.7) 8.9`
--     + `sum . replicate 5 . max 6.7 $ 8.9`

-- %%
replicate 3 (product (map (*3) (zipWith max [1..5] [6..10])))
replicate 3 . product . map (*3) . zipWith max [1..5] $ [6..10]

-- %% markdown
-- "point free style" (or "pointless style") function definition:
-- ```haskell
-- sum' :: (Num a) => [a] -> a
-- sum' - foldr (+) 0 -- no `xs` on both side
-- ```
--
-- ```haskell
-- fn x = ceiling (negate (tan (cos (max 50 x))))
-- ```
-- can be defined
-- ```haskell
-- fn = ceiling . negate . tan . cos . max 50
-- ```
--
-- caveat: a huge composition chain can be less readable, which compositing a long chain can be happy for programmers ...
-- - `oddSquareSum = sum (takeWhile (<10000) (filter odd (map (^2) [1..])))`: agh ...
-- - `oddSquareSum = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]`: another agh ...
-- - ⟹ use `let` (when there's a chance of someone else reading this)

-- %%
oddSquareSum =
  let oddSquares = filter odd $ map (^2) [1..]
      belowLimit = takeWhile (<10000) oddSquares
  in sum belowLimit
