/-
Copyright (c) 2022 Yaël Dillies. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Yaël Dillies
-/

import Mathlib.Tactic.Positivity
import Mathlib.Data.FunLike.Basic

/-!
# Algebraic order homomorphism classes

This file defines hom classes for common properties at the intersection of order theory and algebra.

## Typeclasses

* `NonNegHomClass`: Homs are nonnegative: `∀ f a, 0 ≤ f a`
* `SubAdditiveHomClass`: Homs are subadditive: `∀ f a b, f (a + b) ≤ f a + f b`
* `SubMultiplicativeHomClass`: Homs are submultiplicative: `∀ f a b, f (a * b) ≤ f a * f b`
* `MulLEAddHomClass`: `∀ f a b, f (a * b) ≤ f a + f b`
* `NonArchimedeanHomClass`: `∀ a b, f (a + b) ≤ max (f a) (f b)`

## TODO

Finitary versions of the current lemmas.
-/

open Function

variable {ι F α β γ δ : Type _}

/-- `NonNegHomClass F α β` states that `F` is a type of nonnegative morphisms. -/
class NonNegHomClass (F : Type _) (α β : outParam (Type _)) [Zero β] [LE β] extends
  FunLike F α fun _ => β where
  /-- the image of any element is non negative. -/
  map_nonneg (f : F) : ∀ a, 0 ≤ f a
#align nonneg_hom_class NonNegHomClass

/-- `SubAdditiveHomClass F α β` states that `F` is a type of subadditive morphisms. -/
class SubAdditiveHomClass (F : Type _) (α β : outParam (Type _)) [Add α] [Add β] [LE β] extends
  FunLike F α fun _ => β where
  /-- the image of a sum is less or equal than the sum of the images. -/
  map_add_le_add (f : F) : ∀ a b, f (a + b) ≤ f a + f b
#align subadditive_hom_class SubAdditiveHomClass

/-- `SubMultiplicativeHomClass F α β` states that `F` is a type of submultiplicative morphisms. -/
@[to_additive SubAdditiveHomClass]
class SubMultiplicativeHomClass (F : Type _) (α β : outParam (Type _)) [Mul α] [Mul β] [LE β]
  extends FunLike F α fun _ => β where
  /-- the image of a product is less or equal than the product of the images. -/
  map_mul_le_mul (f : F) : ∀ a b, f (a * b) ≤ f a * f b
#align submultiplicative_hom_class SubMultiplicativeHomClass

/-- `MulLEAddHomClass F α β` states that `F` is a type of subadditive morphisms. -/
@[to_additive SubAdditiveHomClass]
class MulLEAddHomClass (F : Type _) (α β : outParam (Type _)) [Mul α] [Add β] [LE β]
  extends FunLike F α fun _ => β where
  /-- the image of a product is less or equal than the sum of the images. -/
  map_mul_le_add (f : F) : ∀ a b, f (a * b) ≤ f a + f b
#align mul_le_add_hom_class MulLEAddHomClass

/-- `NonArchimedeanHomClass F α β` states that `F` is a type of non-archimedean morphisms. -/
class NonArchimedeanHomClass (F : Type _) (α β : outParam (Type _)) [Add α] [LinearOrder β]
  extends FunLike F α fun _ => β where
  /-- the image of a sum is less or equal than the maximum of the images. -/
  map_add_le_max (f : F) : ∀ a b, f (a + b) ≤ max (f a) (f b)
#align nonarchimedean_hom_class NonArchimedeanHomClass

export NonNegHomClass (map_nonneg)

export SubAdditiveHomClass (map_add_le_add)

export SubMultiplicativeHomClass (map_mul_le_mul)

export MulLEAddHomClass (map_mul_le_add)

export NonArchimedeanHomClass (map_add_le_max)

attribute [simp] map_nonneg

@[to_additive]
theorem le_map_mul_map_div [Group α] [CommSemigroup β] [LE β] [SubMultiplicativeHomClass F α β]
    (f : F) (a b : α) : f a ≤ f b * f (a / b) := by
  simpa only [mul_comm, div_mul_cancel'] using map_mul_le_mul f (a / b) b
#align le_map_mul_map_div le_map_mul_map_div

@[to_additive]
theorem le_map_add_map_div [Group α] [AddCommSemigroup β] [LE β] [MulLEAddHomClass F α β] (f : F)
    (a b : α) : f a ≤ f b + f (a / b) := by
  simpa only [add_comm, div_mul_cancel'] using map_mul_le_add f (a / b) b
#align le_map_add_map_div le_map_add_map_div

@[to_additive]
theorem le_map_div_mul_map_div [Group α] [CommSemigroup β] [LE β] [SubMultiplicativeHomClass F α β]
    (f : F) (a b c : α) : f (a / c) ≤ f (a / b) * f (b / c) := by
  simpa only [div_mul_div_cancel'] using map_mul_le_mul f (a / b) (b / c)
#align le_map_div_mul_map_div le_map_div_mul_map_div

@[to_additive]
theorem le_map_div_add_map_div [Group α] [AddCommSemigroup β] [LE β] [MulLEAddHomClass F α β]
    (f : F) (a b c : α) : f (a / c) ≤ f (a / b) + f (b / c) := by
    simpa only [div_mul_div_cancel'] using map_mul_le_add f (a / b) (b / c)
#align le_map_div_add_map_div le_map_div_add_map_div

--namespace Mathlib.Meta.Positivity

--Porting note: tactic extension commented as decided in the weekly porting meeting
-- /-- Extension for the `positivity` tactic: nonnegative maps take nonnegative values. -/
-- @[positivity _ _]
-- unsafe def positivity_map : expr → tactic strictness
--   | expr.app (quote.1 ⇑(%%f)) (quote.1 (%%ₓa)) => nonnegative <$> mk_app `` map_nonneg [f, a]
--   | _ => failed
-- #align tactic.positivity_map tactic.positivity_map

--end Mathlib.Meta.Positivity
