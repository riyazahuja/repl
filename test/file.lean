/-def f : Nat := 37

def g := 2

theorem h : f + g = 39 := by exact rfl-/


variable (P Q R S : Prop)

theorem A : (P → Q) ∧ (Q → R) → P → R := by
  intro h p
  rcases h with ⟨a,b⟩
  apply b
  apply a
  exact p

theorem B (h : P → Q) (h1 : P ∧ R) : Q ∧ R := by
  rcases h1 with ⟨p,r⟩
  constructor
  exact h p
  exact r
