variable (P Q R S : Prop)


theorem F (h1 : P ∨ Q) (h2 : P → R) : R ∨ Q := by
  rcases h1 with a|b
  left
  exact h2 a
  right
  exact b


theorem G (h1 : P ∨ Q → R) : (P → R) ∧ (Q → R) := by
  constructor
  intro p
  have duh : P ∨ Q := by
    left
    exact p
  exact h1 duh
  intro q
  have duh : P ∨ Q := by
    right
    exact q
  exact h1 duh
