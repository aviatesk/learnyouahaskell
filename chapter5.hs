-- %% markdown
-- # Chapter 5 -- Recursion
--

-- %% markdown
-- Recursion: a way of defining functions in which the function is applied inside its own definition
--
-- **edge condition**: an element or two in a recursion definition defined non-recursively
-- - important if we want our recursive function to terminate
--
-- Why recursion is important to Haskell ?
-- > unlike imperative languages, we do computations in Haskell by declaring what something _is_ instead of declaring _how_ we get it.
-- > That's why there are no `while` loops or `for` loops in Haskell and instead we many times have to use recursion to declare what something is.

-- %% markdown
-- `maximum`

-- %%
-- beautiful ...
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "no maximum of empty list"
maximum' [x] = x
maximum' (x:xs)
  | x > maxTail = x
  | otherwise   = maxTail
  where maxTail = maximum' xs

maximum' [2, 5, 1]

-- %%
-- yet more elegant ...
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "no maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)

maximum' [2, 5, 1]

-- %% markdown
-- `replicate`

-- %%
replicate' :: (Num t, Ord t) => t -> a -> [a]
replicate' n x
  | n <= 0    = []
  | otherwise = x:replicate' (n-1) x

replicate' 3 5

-- %% markdown
-- NOTE:
-- `Num` is not a subclass of `Ord`. That means that what constitutes for a number doesn't really have to adhere to an ordering.
-- So that's why we have to specify both the `Num` and `Ord` class constraints when doing addition or subtractions and also comparison.

-- %% markdown
-- `take`:
-- - `take 3 [5,4..1]` will return `[5,4,3]`
-- - two edge cases:
--   * when trying to `take` 0 or less elements from a list
--   * when trying to take anything from an empty list

-- %%
take' :: (Num t, Ord t) => t -> [a] -> [a]
take' n _
  | n <= 0     = [] -- NOTE: otherwise fall through to the next pattern
take' _ []     = []
take' n (x:xs) = x : take' (n-1) xs

take' 3 [5,4..1]

-- %% markdown
-- - the first pattern handles when we try to take a 0 or negative number of elements (edge case)
--   * NOTE: we're using `_` to match the list because we don't really care what it is in this case
--   * NOTE: we use a guard, but without an `otherwise` part, meaning that **if `n` turns out to be more than 0, the matching will fall through to the next pattern**
-- - the second pattern handles when we try to take anything from an empty list (edge case)
-- - the third pattern handles general cases

-- %% markdown
-- `reverse`

-- %%
reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]

reverse' [1..10]

-- %% markdown
-- `repeat`
--
-- Because Haskell supports infinite lists, our recursion doesn't really have to have an edge condition:
-- - `repeat` can be implemented really easily
-- - we can cut infinite lists where we want

-- %%
repeat' :: a -> [a]
repeat' x = x : repeat x

take 5 (repeat' 3) -- essentially same as `replicate 5 3`

-- %% markdown
-- `zip`

-- %%
-- NOTE: there're two edge conditions !
zip' :: [a] -> [b] -> [(a,b)]
zip' _ []          = []
zip' [] _          = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

zip' [1..10] ['a'..'j']
zip' [1..10] ['a'..'z']

-- %% markdown
-- `elem`

-- %%
elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
  | a == x    = True
  | otherwise = a `elem'` xs

's' `elem'` ['a'..'z']

-- %% markdown
-- Quick Sort !
--
-- > Quicksort has become a sort of poster child for Haskell. ... even though implementing quicksort in Haskell is considered really cheesy because everyone does it to showcase how elegant Haskell is.
--
-- - edge case: empty list (again ! a sorted empty list is an empty list)
-- - a sorted list **is** a list that has all the values smaller than (or equal to) the head of the list in front (and those values are **sorted**), then comes the head of the list in the middle and then come all the values that are bigger than the head (they're also **sorted**)
--   * "sorted" appears two times in the definition: we'll probably have to make the recursive call twice !
--   * the algorithm is defined using the verb "is", instead of saying "do this, do that, then do that ..."; the beauty of functional programming !
--
-- NOTE:
-- The algorithm below is a quicksort with a deterministic pivot; we choose the head `x` because it's easy to get by pattern matching.

-- %%
quicksort :: (Ord a) => [a] -> [a]
quicksort []     = [] -- an empty list is already sorted in a way, by virtue of being empty
quicksort (x:xs) =
  smallerSorted ++ [x] ++ biggerSorted
  where smallerSorted = quicksort [ a | a <- xs, a <= x ]
        biggerSorted  = quicksort [ a | a <- xs, a > x ]

quicksort [10,2,5,3,1,6,7,4,2,3,4,8,9]
quicksort "the quick brown fox jumps over the lazy dog."

-- %% markdown
-- ## Thinking Recursively
--
-- Recursion pattern: defined an edge case and then define a function that does something between some element and the function applied to the rest:
-- - edge case: some scenario where a recursive application doesn't make sense
--   * **Often the edge case value turns out to be an identity**:
--     + e.g.: the identity of multiplication is 1: multiply something by 1, we get that something (identity) back
--     + e.g.: in quicksort, the identity is the empty list: if we add an empty list to a list, we just get the original back
--   * e.g.: when dealing with lists, it is most often the empty list
--   * e.g.: when dealing with trees, it is usually a node that doesn't have any children
-- - when trying to think about a recursive way to solve a problem, try to think of when a recursive solution doesn7t apply and see if we can use that as an edge case, think about identities and think about whether we'll break apart the parameters of the function and on which part we'll use the recursive call
