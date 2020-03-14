-- %% markdown
-- # Chapter 4 -- Syntax in Functions
--

-- %%
-- IHaskell settings
:opt no-lint
:opt no-pager

-- %% markdown
-- ## Pattern Matching
-- Pattern matching consists of:
-- - specifying patterns to which some data should _conform_
-- - checking to see if it does
-- - deconstructing the data according to those patterns
--
-- When defining functions, we can define separate function bodies for different patterns.
-- This appears to be like the Julia dispatch on different type objects but Haskell can pattern match on _any_ data type – numbers, characters, lists, tuples, etc.

-- %%
lucky :: (Integral a) => a -> String
lucky 7 = "Lucky number seven !"
lucky x = "You're out of luck, pal !"

lucky 7
lucky 10

-- %% markdown
-- Note that patterns will be check from top to bottom and when it conforms to a pattern, the corresponding function body will be used.
-- So if we move the second function body up, it will catch all the numbers and they won't have a chance to fall through and be checked for the first pattern.
-- %%
lucky :: (Integral a) => a -> String
lucky x = "You're out of luck, pal !"
lucky 7 = "Lucky number seven !"

lucky 7
lucky 10

-- %% markdown
-- Order is important when specifying patterns and it's always best to ***specify the most specific ones first and then the more general ones later***: e.g. `factorial` function (pattern match & recursion)
-- %%
factorial :: (Integral a) => a -> a

-- the orders can't be inverted
factorial 0 = 1
factorial n = n * factorial (n - 1)
factorial 5

-- %% markdown
-- Pattern matching can also fail; when we have non-exhausive patterns.
-- When making patterns, we should always include a catch-all pattern so that our program doesn't crash if we get some unexpected input.
-- %%
charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"

charName 'a'
charName 'b'
charName 'h'

-- %% markdown
-- Pattern matching on tuples
-- %%
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors a b = (fst a + fst b, snd a + snd b)
addVectors (1, 1) (2, 2)
-- vs.
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
addVectors (1, 1) (2, 2)

-- %% markdown
-- `_` means the same thing as it does in list comprehensions.
-- It means that we really don't care what that part is, so we just write a `_`.
-- E.g.: `fst` and `snd` on tuples
-- %%
first :: (a, b, c) -> a
first (x, _, _) = x
second :: (a, b, c) -> b
second (_, y, _) = y
third :: (a, b, c) -> c
third (_, _, z) = z

first (1, 2, 3)
second (1, 2, 3)
third (1, 2, 3)

-- %% markdown
-- Pattern matching in list comprehensions:
-- Should a pattern match fail, it will just move on to the next element
-- %%
let xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)]
[ a + b | (a, b) <- xs ]

-- %% markdown
-- Pattern matching on lists:
-- - We can match with the empty list `[]` or any pattern that involves `:` and the empty list
-- - We can also use `[1, 2, 3]`-style syntax sugar
-- - A pattern like `x:xs` will bind the head of the list to `x` and the rest of it to `xs`, even if there's only one element so `xs` ends up being an empty list
--   * This pattern is used a lot, especially with recursive functions.
--     But note that patterns that have `:` in them **only match against lists of length 1 or more**
--
-- E.g.: Our own implementation of the `head` function
-- %%
head' :: [a] -> a
head' [] = error "Can't call head on an empty list, dummy !"
head' (x:_) = x

head' [4, 5, 5]
head' "Hello"

-- %% markdown
-- MEMO:
-- The `error` function takes a string and generates a runtime error, using the string as information about what kind of error occured.
-- It causes the program to crash, so it's not good to use it too much.

-- %% markdown
-- More pattern matching exmaples:

-- %%
tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell (x:[]) = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This list is long; the first two elements are: " ++ show x ++ " and " ++ show y

tell []
tell [1]
tell [1,2]
tell [1..100]

-- %%
length' :: (Num b) => [a] -> b
length' [] = 0 -- edge condition
length' (_:xs) = 1 + length' xs

length' [1,2]
length' [1..10]
length' "ham" -- polymorphism !

-- %%
sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

sum' [1..1000]
sum' [1,3..1000]

-- %% markdown
-- ### As Patterns
-- Those are a handy way of breaking something up according to a pattern and binding it to names whilst still keeping a reference to the whole thing.
--
-- Put a name and an `@` in front of a pattern, e.g. `xs@(x:y:ys)`:
-- will match exactly the same thing as `x:y:ys` but we can easily get the whole list via `xs` instead of repeating ourselves by typign out `x:y:ys` in the function body again.

-- %%
capital :: String -> String
capital "" = "Empty string, whoops !"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]
capital "Shuhei"


-- %% markdown
-- ## Guards

-- %%
bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
  | bmi <= 18.5 = "You're underweight, you emo, you !"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly !"
  | bmi <= 30.0 = "You're fat ! Lose some weight, fatty !"
  | otherwise   = "You're a whale, congratulations !"
bmiTell 23.5

-- %% markdown
-- - Guards are indicated by pipes that follow a function's name and its parameters
--   * Usually, they're indented a bit to the right and lined up
-- - A guard is basically a boolean expression.
--   * If it evaluates to `True`, then the corresponding function body is used
--   * If it evaluates to `False`, checking drops through to the next guard and so on
-- - Guards are a very nice alternative for a big `if`/`else` tree in imperative languages; only this is far better and more readable
-- - `otherwise` is defined simply as `otherwise = True` and catches everything
-- - If all the guards of a function evaluate to `False`, evaluation falls through to the next ***pattern***; how patterns and guards play nicely together
--
-- NOTE: there's no `=` right after the function name and its parameters, before the first guard

-- %%
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
  | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you !"
  | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly !"
  | weight / height ^ 2 <= 30.0 = "You're fat ! Lose some weight, fatty !"
  | otherwise   = "You're a whale, congratulations !"
bmiTell 75.0 1.85

-- %%
compare' :: (Ord a) => a -> a -> Ordering
a `compare'` b
  | a > b     = GT
  | a == b    = EQ
  | otherwise = LT
1 `compare'` 2


-- %% markdown
-- ## `where` Bindings
--
-- We wrote;
-- ```haskell
-- bmiTell :: (RealFloat a) => a -> a -> String
-- bmiTell weight height
--   | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you !"
--   | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly !"
--   | weight / height ^ 2 <= 30.0 = "You're fat ! Lose some weight, fatty !"
--   | otherwise   = "You're a whale, congratulations !"
-- bmiTell 75.0 1.85
-- ```
-- ... Repeating ourselves three times while programming is about as desirable as getting kicked inna head.

-- %%
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
  | bmi <= 18.5 = "You're underweight, you emo, you !"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly !"
  | bmi <= 30.0 = "You're fat ! Lose some weight, fatty !"
  | otherwise   = "You're a whale, congratulations !"
  where bmi = weight / height ^ 2
bmiTell 75 1.85

-- %% markdown
-- Guard:
-- - put the keyword `where` after the guards, and then define several names and functions
--   * usually it's best to indent it as much as the pipes are indented
-- - these names are visible across the guards; and thus no repeating the same thing !
--   * they are only visible to that function, so we don't have to worry about them polluting the namespace of other functions
--
-- Advantages:
-- - maintainability: we only have to change the one place
-- - readability: by giving names to things
-- - performance: stuff like `bmi` variable here is calculated only once
--
-- NOTE:
-- `where` bindings aren't shared across function bodies of different patterns.
-- If we want several patterns of one function to access some shared name, we have to define it globally.

-- %%
-- Multiple names in a single `where` section
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
  | bmi <= skinny = "You're underweight, you emo, you !"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly !"
  | bmi <= fat    = "You're fat ! Lose some weight, fatty !"
  | otherwise     = "You're a whale, congratulations !"
  -- NOTE: all the names should be aligned at a single column
  where bmi = weight / height ^ 2
        skinny = 18.5
        normal = 25.0
        fat    = 30.0
bmiTell 75 1.85

-- %% markdown
-- Pattern match in `where` bindings:
-- ```haskell
-- ...
-- where bmi = weight / height ^ 2
--       (skinny, normal, fat) = (18.5, 25.0, 30.0)
-- ```
--
-- ```haskell
-- -- pattern match in where section
-- initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
--   where (f:_) = firstname
--         (l:_) = lastname
-- initials "Shuhei" "Kadowaki"
-- ```
-- is same as
-- ```haskell
-- -- pattern match in function's parameters
-- initials (f:_) (l:_) = [f] ++ ". " ++ [l] ++ "."
-- initials "Shuhei" "Kadowaki"
-- ```

-- %% markdown
-- Define functions in `where` blocks
-- %%
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [ bmi w h | (w, h) <- xs ]
  where bmi weight height = weight / height ^ 2

-- %% markdown
-- Nested `where` bindings;
-- it's a common idiom to make a function and define some helper function in its `where` clause
-- and then to give those functions helper functions as well, eatch with its own `where` clause


-- %% markdown
-- ## `let` Bindings
--
-- Very similar to `where` bindings are `let` bindings:
--
-- |         | location                                                                   | scope                                                     |
-- |---------|----------------------------------------------------------------------------|-----------------------------------------------------------|
-- | `where` | syntactic construct that let us bind to variables at the end of a function | the whole function can see them, including all the guards |
-- | `let`   | let us bind to variables anywhere, and name comes first                    | very local, so don't span across guards                   |

-- %%
-- `let` bindings in action:
cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
  let sideArea = 2 * pi * r * h
      topArea  = pi * r ^ 2
  in  sideArea + 2 * topArea
cylinder 1 2

-- %% markdown
-- `let <bindings> in <expression>` form:
-- - the names that you define in the `let` part are accessible to the expression to after the `in` part
-- - puts bindings first and the expression that uses them later
--
-- `let` bindings are expressions themselves:
-- - c.f.: `if`/`else` statement is an expression and we can cram it in almost anywhere
-- - c.f.: `where` bindings are just syntactic constructs

-- %%
-- let bindings
4 * (let a = 9 in a + 1) + 2

-- local function
[let square x = x * x in (square 5, square 3, square 2)]

-- inline bindings (with semicolons)
(let a = 100; b = 200; c = 300 in a * b * c, let foo = "Hey "; bar = "there !" in foo ++ bar)

-- pattern match with `let` bindings
(let (a, b, c) = (1, 2, 3) in a + b + c) * 100

-- %% markdown
-- `let` inside a list comprehension:
-- - it doesn't filter the list, it only binds to names
-- - the names introduced are visible to the output function (the part before the `|`) and all predicate and sections that come after of the binding

-- %%
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [ bmi | (w, h) <- xs, let bmi = w / h ^ 2, bmi >= 25.0 ]

-- %% markdown
-- `in` clause:
-- - not necessary in list comphension: the visibility of the names is already predefined there
-- - if omitted when defining functions and constants directly in GHCI, then the names will be visible throughout the entire interactive session

-- %%
let zoot x y z = x * y + z
zoot 3 9 2

let boot x y z = x * y + z in boot 3 4 2
boot -- should error

-- %% markdown
-- Why not always `let` instead of `where` ?
-- - `let` bindings are expressions and fairly local in their scope, they can't be used across guards
-- - the names introduced by `where` come after the function they're being used in; that way, the function body is close to its name and type declaration (and so maybe more readble)


-- %% markdown
-- ## Case Expressions
--
-- In Haskell:
-- - case expressions are expressions, much like `if`/`else` expressions and `let` bindings
-- - not only can we evaluate expressions based on the possible cases of the value of a variable, we can also do pattern matching:

-- %%
head' :: [a] -> a
head' [] = error "No head for empty lists !"
head' (x:_) = x
-- %% markdown
-- is same as
-- %%
head' :: [a] -> a
head' xs = case xs of [] -> error "No head for empty lists !"
                      (x:_) -> x

-- %% markdown
-- ```haskell
-- case expression of pattern1 -> result1
--                    pattern2 -> result2
--                    pattern3 -> result3
--                    ...
-- ```
--
-- `expression` is matched against the `pattern`s:
-- - the pattern matching action is the same as expected; the first pattern that matches the expression is used
-- - if it falls through the whole case expression and no suitable pattern is found, a runtime error occurs
--
-- c.f.: pattern matching on parameters in function definitions:
-- - **that's actually just syntactic sugar for case expressions !**
-- - v.s.:
--   * pattern matching on function parameters: can only be done when defining functions
--   * case expressions can be used pretty much anywhere

-- %%
describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of []  -> "empty."
                                               [x] -> "a single list."
                                               xs  -> "a longer list."

describeList' :: [a] -> String
describeList' xs = "The list is " ++ what xs
  where what []  = "empty."
        what [x] = "a singleton list."
        what xs  = "a longer list."

describeList "Shuhei"
describeList' "Shuhei"
