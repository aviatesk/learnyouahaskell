-- %% markdown
-- # Chapter 7 -- Modules

-- %%
-- IHaskell settings
:opt no-lint
:opt no-pager

-- %% markdown
-- - Haskell module: a collection of related functions, types and typeclasses.
-- - Haskell program: a collection of modules where the main module loads up the other modules and then uses the functions defined in them to do something
-- - e.g. `Prelude` module is loaded automatically into the interactive session
--
-- Syntaxes:
-- - `import <module>`: imports all the exported functions in `module`
--   * in GHCI: `λ :m + Data.List Data.Map Data.Set`
-- - `import <module> (<func1>, <func2>, ...)`: only imports `func1`, `func2`, ... from `module`
-- - `import <module> hiding (<func>)`: imports all the functions except `func` from `module`
-- - `import qualified <module> (as <name>)`: qualified import to avoid name collisions

-- %%
import Data.List (nub)
numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub

-- %% markdown
-- useful references:
-- - [Haskell Hierarchical Libraries](https://downloads.haskell.org/~ghc/latest/docs/html/libraries/)
-- - [Hoogle](https://hoogle.haskell.org/)


-- %% markdown
-- ## `Data.List`

-- %%
import Data.List

-- %%
intersperse '.' "MONKEY"
intersperse 0 [1..6]

-- %%
intercalate " " ["hey", "there", "guys"]
intercalate [0,0,0] [[1..3], [4..6], [7..9]]

-- %%
transpose [[1..3], [4..6], [7..9]]
transpose ["hey", "there", "guys"]

-- %% markdown
-- e.g.: sum up the polynomials $3x^2 + 5x + 9$, $10x^3 + 9$, $8x^3 + x - 1$

-- %%
map sum $ transpose [[0,3,5,9], [10,0,0,9], [8,0,1,-1]]

-- %% markdown
-- `foldl'`, `foldl1'`: non-lazy left-folds, i.e. intermediate accumulators will be computed immediately as they go along instead of creating stack thunk

-- %%
concat ["foo", "bar", "baz"]
concat [["foo", "bar", "baz"], ["foooo"]] -- remove only one level nesting

-- %%
concatMap (replicate 4) [1..3]

-- %%
and $ map (>4) [1..10]

or $ map (>4) [1..10]

-- `any` and `all` are usually preferred over `and` or `or`
all (>4) [1..10]
any (>4) [1..10]
any (`elem` ['A'..'Z']) "Shuhei Kadowaki"

-- %%
-- returns infinite list
take 10 $ iterate (*2) 1
take 3 $ iterate (++ "haha") ""

-- %%
splitAt 3 "hayman"
splitAt 1000 "heyman"
splitAt (-3) "heyman"

-- %%
-- once predicate equates to `False`, it returns the rest of the list
dropWhile (/= ' ') "This is a sentence"
dropWhile (<3) [1,2,2,3,4,5,4,3,2,2,1]

-- %%
let (fw, rest) = span (/=' ') "This is a sentence" in
  "first word: " ++ fw ++ ", the rest:" ++ rest

let (fw, rest) = break (==' ') "This is a sentence" in
  "first word: " ++ fw ++ ", the rest:" ++ rest

-- %%
group [1,1,2,2,3,4,4,2,3]

map (\l@(x:xs) -> (x, length l)) . group . sort $ [1,1,2,2,3,4,4,2,3]

-- %%
inits "w00t"
tails "w00t"

-- search for a sublist
search :: (Eq a) => [a] -> [a] -> Bool
search needle haystack =
  let nlen = length needle
  in foldl (\acc x -> if take nlen x == needle then True else acc) False $ tails haystack
search "at" "aviatesk"

-- fwiw, this errors, of course
-- "at" `elem` "aviatesk"

-- from `Data.List`
"at" `isInfixOf` "aviatesk"
"ae" `isInfixOf` "aviatesk"

"av" `isPrefixOf` "aviatesk"
"at" `isPrefixOf` "aviatesk"
"sk" `isSuffixOf` "aviatesk"
"av" `isSuffixOf` "aviatesk"

-- %%
partition (`elem` ['A'..'Z']) "Shuhei Kadowaki"
span (`elem` ['A'..'Z']) "Shuhei Kadowaki" -- c.f.

-- %%
:t find
find (==5) [1..10]
find (>10) [1..10]

:t findIndex
findIndex (==' ') "Where are the spaces ?"

:t elemIndex
5 `elemIndex` [1..10]
100 `elemIndex` [1..10]

-- %% markdown
-- quick notes on `Maybe`:
-- - `Maybe` value can either be `Just something` or `Nothing`
-- - `Maybe` value can either be no elements or a single element
--
-- e.g.: instead of `head (dropWhile pred list)`
-- - `head` is not really safe; getting the `head` of an empty list would result in an error
-- - `find pred list` is much safer; we can branch on `Nothing` or `Just`

-- %%
-- `findIndices` and `elemIndices` don't need to return `Maybe`, since it returns a list
:t findIndices
findIndices (`elem` ['A'..'Z']) "Where Are The Caps ?"

:t elemIndices
' ' `elemIndices` "Where are the spaces ?"

-- %%
-- string utilties
lines "first line\nsecond line\nthird line"
unlines . lines $ "first line\nsecond line\nthird line"
words "hey there are the words in this sentence"
words "hey there      are    the words in this\nsentence"
unwords . words $ "hey there are the words in this sentence"

-- %%
nub [1,2,3,4,3,2,1,2,3,4,3,2,1]
sort . nub $ "Lots of words and stuff"

delete 'a' "aviatesk"
delete 'a' . delete 'a' $ "aviatesk"
delete 'z' "aviatesk"

-- %%
-- list difference function
[1..10] \\ [2,5,9]
-- NOTE where the deletion occurs
"aviatesk" \\ "at" -- same as `delete 'a' . delete 't' $ "aviatesk"`

-- %%
"hey man" `union` "man what's up" -- NOTE: duplicates are removed from the second list !
[1..7] `union` [5..10]

-- %%
[1..7] `intersect` [5..10]

-- %% markdown
-- > `insert` takes an element and a list of elements that can be sorted and inserts it into the last position where it's still less than or equal to the next element.
-- > In other words, `insert` will start at the beginning of the list and then keep going until it finds an element that's equal to or greater than the element that we're inserting and it will insert it just before the element.

-- %%
insert 4 [3,5,1,2,8,2]
insert 4 [1,23,4,4,1]

-- against sorted list; the resulting list will be kept sortede
insert 4 $ [1..3] ++ [5..10]

-- %% markdown
-- `length`, `take`, `drop`, `splitAt`, `!!`, `replicate`'s history:
-- - they only take `Int` as one of their parameters (or return an `Int`)
-- - could be more generic and usable if they just took any type that's part of the `Integral` and `Num` typeclasses, depending on the functions
-- - from historic reasons (mainly about backward compatibilities), `Data.List` has their more generic equivalents, named `genericLength`, `genericTake`, `genericDrop`, `genericSplitAt`, `genericIndex` and `genericReplicate`

-- %%
:t length
:t genericLength

-- let xs = [1..7] in sum xs / length xs -- ERROR: because we can't use `/` with an `Int`
let xs = [1..7] in sum xs / genericLength xs

-- %% markdown
-- ### `By` functions
--
-- `nub`, `delete`, `union`, `intersect` and `group` can be more general, e.g. `groupBy`.

-- %%
-- we want to segment the list below into sublists based on when the value was below zero and when it went above
let values = [-4.3, -2.4, -1.2, 0.4, 2.3, 5.9, 10.5, 29.1, 5.3, -2.4, -14.5, 2.9, 2.3]
groupBy (\x y -> (x > 0) == (y > 0)) values

-- %% markdown
-- The `By` function can even more fancier if we use `on` function from `Data.Function`:
-- ```haskell
-- on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
-- f `on` g = \x y -> f (g x) (g y)
-- ```

-- %%
import Data.Function (on)

-- reads: "group values by equality on whether the elements are greater than zero"
groupBy ((==) `on` (>0)) values

-- %% markdown
-- similar idea for `sort`, `insert`, `maximum` and `minimum`, e.g. `sortBy`

-- %%
:t sortBy

-- compare lists based on its length rather than lexicographical order
let xs = [[5,4,5,4,4],[1,2,3],[3,5,4,3],[],[2],[2,2]] in
  sortBy (compare `on` length) xs

-- %% markdown
-- common patterns for `By` functions and `on` function:
-- - `By` functions that take an equality function: `(==) on something`
-- - `By` functions that take an ordering function: `compare on something`


-- %% markdown
-- ## `Data.Char`
--
-- Predicates over characters: `Char -> Bool`
-- - `isControl` checks whether a character is a control character.
-- - `isSpace` checks whether a character is a white-space characters. That includes spaces, tab characters, newlines, etc.
-- - `isLower` checks whether a character is lower-cased.
-- - `isUpper` checks whether a character is upper-cased.
-- - `isAlpha` checks whether a character is a letter.
-- - `isAlphaNum` checks whether a character is a letter or a number.
-- - `isPrint` checks whether a character is printable. Control characters, for instance, are not printable.
-- - `isDigit` checks whether a character is a digit.
-- - `isOctDigit` checks whether a character is an octal digit.
-- - `isHexDigit` checks whether a character is a hex digit.
-- - `isLetter` checks whether a character is a letter.
-- - `isMark` checks for Unicode mark characters. Those are characters that combine with preceding letters to form letters with accents. Use this if you are French.
-- - `isNumber` checks whether a character is numeric.
-- - `isPunctuation` checks whether a character is punctuation.
-- - `isSymbol` checks whether a character is a fancy mathematical or currency symbol.
-- - `isSeparator` checks for Unicode spaces and separators.
-- - `isAscii` checks whether a character falls into the first 128 characters of the Unicode character set.
-- - `isLatin1` checks whether a character falls into the first 256 characters of Unicode.
-- - `isAsciiUpper` checks whether a character is ASCII and upper-case.
-- - `isAsciiLower` checks whether a character is ASCII and lower-case.

-- %%
import Data.Char

all isAlphaNum "aviatesk1234"
all isAlphaNum "edday the fish !"

words "hey guys it's me"
groupBy ((==) `on` isSpace) "hey guys it's me"
filter (not . any isSpace) . groupBy ((==) `on` isSpace) $ "hey guys it's me"

-- %% markdown
-- `GeneralCategory` type: a few possible categories that a character can fall into

-- %%
generalCategory ' '
generalCategory 'A'
generalCategory 'a'
generalCategory '!'
generalCategory '1'
map generalCategory " \t\nA1?!"

filter (\c -> generalCategory c /= Space) "filter out whitespaces !"

-- %% markdown
-- - `toUpper` converts a character to upper-case. Spaces, numbers, and the like remain unchanged.
-- - `toLower` converts a character to lower-case.
-- - `toTitle` converts a character to title-case. For most characters, title-case is the same as upper-case.
-- - `digitToInt` converts a character to an Int. To succeed, the character must be in the ranges `'0'..'9'`, `'a'..'f'` or `'A'..'F'`.
-- - `intToDigit` is the inverse function of `digitToInt`. It takes an Int in the range of `0..15` and converts it to a lower-case character.

-- %%
map digitToInt "34128"
map digitToInt "FF85AB"

intToDigit 15
intToDigit 5

-- %% markdown
-- `ord` and `chr` functions convert characters to their corresponding numbers and vice versa

-- %%
ord 'a'
chr 97
map ord "aviatesk"

-- Caesar cipher; encoding messages by shifting each character in them by a fixed number of positions in the alphabet
encode :: Int -> String -> String
encode shift msg =
  let ords = map ord msg
      shifted = map (+ shift) ords
  in map chr shifted
-- encode shift msg = map (chr . (+ shift) . ord) msg

encode 3 "Heeeey"
encode 4 "Heeeey"
encode 5 "aviatesk in the house !"

decode :: Int -> String -> String
decode shift = encode (negate shift)
-- decode shift code = map (chr . (subtract shift) . ord) code

let shift = 5 in
  let code = encode shift "aviatesk in the house !" in
    decode shift code

-- %% markdown
-- ## `Data.Map`
--
