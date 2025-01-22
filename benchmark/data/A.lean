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

theorem C (h : ¬ (P ∧ Q)) : P → ¬ Q := by
  intro p opp
  have duh : P ∧ Q := by
    constructor
    exact p
    exact opp
  exact h duh

theorem D (h : ¬ (P → Q)) : ¬ Q := by
  intro opp
  have duh : P → Q := by
    intro _
    exact opp
  exact h duh

theorem E (h : P ∧ ¬ Q) : ¬ (P → Q) := by
  rcases h with ⟨p,nq⟩
  intro huh
  have duh := huh p
  contradiction

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


theorem H (h1 : P → R) (h2 : Q → R) : P ∨ Q → R := by
  intro pq
  rcases pq with a|b
  exact h1 a
  exact h2 b

theorem I (h : ¬ (P ∨ Q)) : ¬ P ∧ ¬ Q := by
  constructor
  intro p
  have duh : P∨ Q := by
    left
    exact p
  exact h duh
  intro q
  have duh : P∨ Q := by
    right
    exact q
  exact h duh

-- this one requires classical logic!
theorem L (h : ¬ (P ∧ Q)) : ¬ P ∨ ¬ Q := by
  have hmm : P → ¬ Q := by
    intro p opp
    have duh : P ∧ Q := by
      constructor
      exact p
      exact opp
    exact h duh



  by_cases duh:P
  right
  exact hmm duh
  left
  exact duh


-- this one too
theorem M (h : P → Q) : ¬ P ∨ Q := by
  by_cases duh:P
  right
  exact h duh
  left
  exact duh
