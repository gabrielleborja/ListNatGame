inductive ListNat where
  | nil
  | cons : Nat → ListNat → ListNat
  deriving Repr

-- LEVEL 1: Recognizing


open ListNat -- Easier to write ListNat things

#check nil -- With open command
#check ListNat.nil -- Without "open ListNat" command
#check cons 0 nil
#eval nil -- deriving Repr








-- LEVEL 2: Defining operations

def length : ListNat → Nat
  | nil => 0
  | cons _ l => length l + 1

#check length nil -- Judgement
#eval length nil -- Evaluation (?)
#eval length (cons 0 nil) -- Fix it

def greatest : ListNat → Nat 
  | nil => 0
  | cons n l=> if greatest l ≥ n then greatest l else n 

#eval greatest nil
#eval greatest (cons 4 (cons 20 (cons 10 nil)))
#eval greatest (cons 1 (cons 1 nil))

-- Assume ordered lists
-- First element greater than n
def upper_bound : Nat → ListNat → Nat
  | n, nil => n
  | n, cons x xs => if x> n then x else upper_bound n xs

#eval upper_bound 1 (cons 3 (cons 4 (cons 8 nil)))
#eval upper_bound 3 (cons 1 (cons 3 (cons 4 (cons 8 nil))))
#eval upper_bound 5 (cons 1 (cons 3 (cons 4 (cons 8 nil))))

-- Assume ordered lists
-- First element not less than n
def lower_bound : Nat → ListNat → Nat
  | n, nil => n
  | n, cons x xs => if x ≥  n then x else lower_bound n xs

#eval lower_bound 0 nil
#eval lower_bound 3 (cons 1 (cons 3 (cons 4 (cons 8 nil))))
#eval lower_bound 5 (cons 1 (cons 3 (cons 4 (cons 8 nil))))

def filter : (Nat → Bool) → ListNat → ListNat
  | _, nil => nil 
  | f, cons x xs => if f x == true then cons x (filter f xs) else filter f xs

open Nat

def even : Nat → Bool
 |0 => true
 |1 => false
 |succ n => if true then even n == false else even n==true
 
#eval filter even nil
#eval filter even (cons 0 (cons 2 (cons 3 nil)))

-- [1,2,3] → [2,4,6]
def doubleList : ListNat → ListNat
  |nil=> nil
  |cons x xs => cons (x*2) (doubleList xs)

def map : (Nat → Nat) → ListNat → ListNat
  |_, nil => nil
  |f, cons x xs => cons (f x) (map f xs)

#eval doubleList nil
#eval doubleList (cons 1 (cons 3 nil))

-- Use \. + space to write · 
#eval map (· * 2) (cons 1 (cons 3 nil))
#eval map (· + 3) (cons 1 nil)


def concat : ListNat → ListNat → ListNat
  |nil, l => l
  |cons x xs, l => cons x (concat xs l)

#eval concat nil nil
#eval concat (cons 1 nil) (cons 3 (cons 4 nil))
-- Yours!

-- Add an nat to the end
def append : Nat → ListNat → ListNat
  |n, nil => cons n nil
  |n, cons x xs => cons x (append n xs)

-- Define append in function of concat

def append_cat : Nat → ListNat → ListNat
  |n, l => concat l (cons n nil) 

#eval append_cat 0 nil
#eval append_cat 3 (cons 0 (nil))
#eval append 0 nil
#eval append 3 (cons 0 (nil))

-- esreveR...
def reverse : ListNat → ListNat
  |nil => nil
  |cons x xs => append x (reverse xs) 

  #eval reverse nil
  #eval reverse (cons 5 (cons 4 (cons 2 (cons 3 (nil)))))
  #eval reverse (cons 4 (cons 1 (nil)))

-- Obviously eval it...

-- LEVEL 3: Theorems

variable (l : ListNat)

theorem same_functions :
  doubleList l = map (· * 2) l :=
by 
  induction l with 
  |nil => 
    rw [doubleList, map]
  |cons x xs h => 
    rw [doubleList, map, h]
    

theorem reverse_nil : reverse nil = nil := rfl

theorem cool_theorem (x : Nat) :
  reverse (append x l) = cons x (reverse l) :=
by
  induction l with
  |nil=>
    rw [append, reverse, reverse, reverse, append]
  |cons x xs h=>
    rw [append, reverse, reverse, h, append]

theorem reverse_reverse :
  reverse (reverse l) = l :=
by
  induction l with 
  |nil=>
    rw [reverse, reverse]
  |cons x xs h=>
    rw [← h, reverse]
    rw [cool_theorem]
    rw [h, h]
    
    
    
    






-- LEVEL 4: Your own theorems

-- Sugestions:
-- Can you think cool theorems about lower_bound and upper_bound?
-- How about append_cat?
-- Buy me a KitKat

-- By Isaac Lourenço 2023, IMD - UFRN, Brazil.
