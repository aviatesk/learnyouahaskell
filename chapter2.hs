-- %% markdown
-- # Chapter 2 -- Starting Out
--

-- %%
-- IHaskell settings
:opt no-lint
:opt no-pager

-- %% markdown
-- ## Basics

-- %% markdown
-- Function
-- %%
doubleMe x = x + x
doubleMe 9
doubleMe 8.3
doubleUs x y = x * 2 + y * 2
doubleUs 4 9
doubleUs 2.3 34.2
doubleUs x y = doubleMe x + doubleMe y
doubleUs 4 9
doubleUs 2.3 34.2
-- %%
doubleSmallNumber x = if x > 100
                        then x
                        else x * 2
doubleSmallNumber' x = (if x > 100 then x else x * 2) + 1 -- NOTE: we need parenthesis for this
doubleSmallNumber' 10 == doubleSmallNumber 10 + 1

-- %% markdown
-- Backtick `\`func\``: make a function with two parameters infix
-- %%
div 92 10
92 `div` 10 -- wao !

-- %% markdown
-- Definition / Name:
-- - function without parameters
-- - once a name is defined, then it never changes
-- %%
name = "Shuhei Kadowaki ?"
let name = "Shuhei Kadowaki" -- `let` is only necessary within GHCi


-- %% markdown
-- ## List
-- ***homogenous***:
-- - `[1, 2]`
-- - `"hello"`: a string is a list of chars

-- %%
[1,2]
"hello"

-- %% markdown
-- `+` and `:`:
-- - `++`: $O(n)$
-- - `:` (cons): $O(1)$
-- %%
"hello" ++ " " ++ "world !"
['w', 'a'] ++ ['o', '!']

'A':" SMALL CAT"
0:[1,2,3]

-- NOTE this is just a syntactic sugar
[1,2,3] == 1:2:3:[]

-- %% markdown
-- Access to elements
-- %%
"Shuhei Kadowaki" !! 0
"Shuhei Kadowaki" !! 7

-- %% markdown
-- List of list, and so on
-- %%
let b = [[1],[2,3]]
b ++ [[4,5,6]]
[]:b
b !! 1

-- %% markdown
-- Comparison: done by lexicographical order
-- %%
[3,2,1] > [2,1,0]

-- %% markdown
-- List functions
-- %%
lst = [5,4,3,2,1]

head lst
-- head []

tail lst

last lst

init lst

length lst

null lst
null []

reverse lst

take 3 lst
take 1 lst
take 10 lst
take 0 lst

drop 3 lst
drop 0 lst
drop 100 lst

maximum lst

minimum lst

sum lst

product lst

4 `elem` lst
0 `elem` lst


-- %% markdown
-- ## Ranges

-- %%
[1..20]
['a'..'z']
[2,4..20] -- wao !
[3,6..20]
-- XXX: ranges with floating point numbers
[0.1, 0.3 .. 1]

-- %% markdown
-- Infinite list
-- %%
[13,26..24*13] == take 24 [13,26..] -- wao !
take 10 (cycle [1,2,3])
take 10 (repeat 5)
replicate 10 5 == take 10 (repeat 5)


-- %% markdown
-- ## List comprehension:
-- - `[ x*2 | x <- [1..10]]`
-- - ref: in mathematics, $S = \{2 \cdot x | x \in \mathbb{N}, x \leq 10\}$

-- %%
[ x*2 | x <- [1..10]]

-- %% markdown
-- Filtering with predicate
-- %%
[ x*2 | x <- [1..10], x*2 >= 12]
[ x | x <- [50..100], x `mod` 7 == 3]

boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]
boomBangs [7..13]

-- %% markdown
-- Multiple predicates
-- %%
[ x | x <- [10..20], x /= 13, x /= 15, x /= 19]

-- %% markdown
-- Multiple inputs
-- %%
[ x*y | x <- [1,10,100], y <- [1,10,100]]
[ x*y | x <- [1,10,100], y <- [1,10,100], x*y > 100]

-- %%
let nouns = ["hobo", "frog", "pope"]
let adjectives = ["lazy", "grouchy", "scheming"]
[ adjective ++ " " ++ noun | adjective <- adjectives, noun <- nouns]

length' xs = sum [ 1 | _ <- xs]
length' [1..10]

-- %% markdown
-- `String`s as lists
-- %%
length' "out of box !"
removeNonUppercase str = [ c | c <- str, c `elem` ['A'..'Z']]
removeNonUppercase "Shuhei Kadowaki"

-- %% markdown
-- List of lists
-- %%
let xxs = [[1..10], [11..20], [22..30]]
[ [ x | x <- xs, even x] | xs <- xxs]


-- %% markdown
-- ## Tuples:
-- - its type depends on how many components it has and the types of the components
-- - non homogenous (different types)
--
-- e.g.: when we try to represent points of a shape on a two-dimensional plane with list
-- - list elements don't work well, since list can be arbitrary legnth
--   * `[[1,2], [8,11,5],[4,5]]`
-- - => tuples ! (its length contributes to its type)

-- %%
[(1,2), (8,11), (4,5)]
-- [(1,2), (8,11,5), (4,5)] -- error

-- %% markdown
-- Tuple functions
-- %%
fst (8, 11)
fst ("Wao", False)

snd (8, 11)
snd ("Wao", False)

zip [1..5] (replicate 5 5)
zip [1..5] ['1'..'5']
zip [1..5] [1..10] -- arguments with different length
zip [1..] ['1'..'5'] -- even with infinite list
