{-# OPTIONS --without-K --exact-split #-}

module book.14-propositional-truncation where

import book.13-function-extensionality-solutions
open book.13-function-extensionality-solutions public

-- Section 13 Propositional truncations and the image of a map

--------------------------------------------------------------------------------

-- Section 13.1 Propositional truncations

-- Definition 13.1.1

precomp-Prop :
  { l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) →
  (A → type-Prop P) → (Q : UU-Prop l3) →
  (type-hom-Prop P Q) → (A → type-Prop Q)
precomp-Prop P f Q g = g ∘ f

is-propositional-truncation :
  ( l : Level) {l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) →
  ( A → type-Prop P) → UU (lsuc l ⊔ l1 ⊔ l2)
is-propositional-truncation l P f =
  (Q : UU-Prop l) → is-equiv (precomp-Prop P f Q)

universal-property-propositional-truncation :
  ( l : Level) {l1 l2 : Level} {A : UU l1}
  (P : UU-Prop l2) (f : A → type-Prop P) → UU (lsuc l ⊔ l1 ⊔ l2)
universal-property-propositional-truncation l {A = A} P f =
  (Q : UU-Prop l) (g : A → type-Prop Q) →
  is-contr (Σ (type-hom-Prop P Q) (λ h → (h ∘ f) ~  g))

-- Some unnumbered remarks after Definition 13.1.1

universal-property-is-propositional-truncation :
  (l : Level) {l1 l2 : Level} {A : UU l1}
  (P : UU-Prop l2) (f : A → type-Prop P) →
  is-propositional-truncation l P f →
  universal-property-propositional-truncation l P f
universal-property-is-propositional-truncation l P f is-ptr-f Q g =
  is-contr-equiv'
    ( Σ (type-hom-Prop P Q) (λ h → Id (h ∘ f) g))
    ( equiv-tot (λ h → equiv-funext))
    ( is-contr-map-is-equiv (is-ptr-f Q) g)

map-is-propositional-truncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
  ({l : Level} → is-propositional-truncation l P f) →
  (Q : UU-Prop l3) (g : A → type-Prop Q) → type-hom-Prop P Q
map-is-propositional-truncation P f is-ptr-f Q g =
  pr1
    ( center
      ( universal-property-is-propositional-truncation _ P f is-ptr-f Q g))

htpy-is-propositional-truncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
  (is-ptr-f : {l : Level} → is-propositional-truncation l P f) →
  (Q : UU-Prop l3) (g : A → type-Prop Q) →
  ((map-is-propositional-truncation P f is-ptr-f Q g) ∘ f) ~ g
htpy-is-propositional-truncation P f is-ptr-f Q g =
  pr2
    ( center
      ( universal-property-is-propositional-truncation _ P f is-ptr-f Q g))

is-propositional-truncation-universal-property :
  (l : Level) {l1 l2 : Level} {A : UU l1}
  (P : UU-Prop l2) (f : A → type-Prop P) →
  universal-property-propositional-truncation l P f →
  is-propositional-truncation l P f
is-propositional-truncation-universal-property l P f up-f Q =
  is-equiv-is-contr-map
    ( λ g → is-contr-equiv
      ( Σ (type-hom-Prop P Q) (λ h → (h ∘ f) ~ g))
      ( equiv-tot (λ h → equiv-funext))
      ( up-f Q g))

-- Remark 13.1.2

is-propositional-truncation' :
  ( l : Level) {l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) →
  ( A → type-Prop P) → UU (lsuc l ⊔ l1 ⊔ l2)
is-propositional-truncation' l {A = A} P f =
  (Q : UU-Prop l) → (A → type-Prop Q) → (type-hom-Prop P Q)

is-propositional-truncation-simpl :
  { l1 l2 : Level} {A : UU l1} (P : UU-Prop l2)
  ( f : A → type-Prop P) →
  ( (l : Level) → is-propositional-truncation' l P f) →
  ( (l : Level) → is-propositional-truncation l P f)
is-propositional-truncation-simpl P f up-P l Q =
  is-equiv-is-prop
    ( is-prop-Π (λ x → is-prop-type-Prop Q))
    ( is-prop-Π (λ x → is-prop-type-Prop Q))
    ( up-P l Q)

-- Example 13.1.3

is-propositional-truncation-const-star :
  { l1 : Level} (A : UU l1) (a : A)
  ( l : Level) → is-propositional-truncation l unit-Prop (const A unit star)
is-propositional-truncation-const-star A a =
  is-propositional-truncation-simpl
    ( unit-Prop)
    ( const A unit star)
    ( λ l P f → const unit (type-Prop P) (f a))

-- Example 13.1.4

is-propositional-truncation-id :
  { l1 : Level} (P : UU-Prop l1) →
  ( l : Level) → is-propositional-truncation l P id
is-propositional-truncation-id P l Q =
  is-equiv-id (type-hom-Prop P Q)

-- Proposition 13.1.5

abstract
  is-equiv-is-equiv-precomp-Prop :
    {l1 l2 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) (f : type-hom-Prop P Q) →
    ((l : Level) (R : UU-Prop l) →
    is-equiv (precomp-Prop Q f R)) → is-equiv f
  is-equiv-is-equiv-precomp-Prop P Q f is-equiv-precomp-f =
    is-equiv-is-equiv-precomp-subuniverse id (λ l → is-prop) P Q f
      is-equiv-precomp-f

triangle-3-for-2-is-ptruncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (P' : UU-Prop l3)
  (f : A → type-Prop P) (f' : A → type-Prop P')
  (h : type-hom-Prop P P') (H : (h ∘ f) ~ f') →
  {l : Level} (Q : UU-Prop l) →
  ( precomp-Prop P' f' Q) ~
  ( (precomp-Prop P f Q) ∘ (precomp h (type-Prop Q)))
triangle-3-for-2-is-ptruncation P P' f f' h H Q g =
  eq-htpy (λ p → inv (ap g (H p)))

is-equiv-is-ptruncation-is-ptruncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (P' : UU-Prop l3)
  (f : A → type-Prop P) (f' : A → type-Prop P')
  (h : type-hom-Prop P P') (H : (h ∘ f) ~ f') →
  ((l : Level) → is-propositional-truncation l P f) →
  ((l : Level) → is-propositional-truncation l P' f') →
  is-equiv h
is-equiv-is-ptruncation-is-ptruncation P P' f f' h H is-ptr-P is-ptr-P' =
  is-equiv-is-equiv-precomp-Prop P P' h
    ( λ l Q →
      is-equiv-right-factor
        ( precomp-Prop P' f' Q)
        ( precomp-Prop P f Q)
        ( precomp h (type-Prop Q))
        ( triangle-3-for-2-is-ptruncation P P' f f' h H Q)
        ( is-ptr-P l Q)
        ( is-ptr-P' l Q))

is-ptruncation-is-ptruncation-is-equiv :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (P' : UU-Prop l3)
  (f : A → type-Prop P) (f' : A → type-Prop P')
  (h : type-hom-Prop P P') (H : (h ∘ f) ~ f') →
  is-equiv h →
  ((l : Level) → is-propositional-truncation l P f) →
  ((l : Level) → is-propositional-truncation l P' f')
is-ptruncation-is-ptruncation-is-equiv P P' f f' h H is-equiv-h is-ptr-f l Q =
  is-equiv-comp
    ( precomp-Prop P' f' Q)
    ( precomp-Prop P f Q)
    ( precomp h (type-Prop Q))
    ( triangle-3-for-2-is-ptruncation P P' f f' h H Q)
    ( is-equiv-precomp-is-equiv h is-equiv-h (type-Prop Q))
    ( is-ptr-f l Q)

is-ptruncation-is-equiv-is-ptruncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (P' : UU-Prop l3)
  (f : A → type-Prop P) (f' : A → type-Prop P')
  (h : type-hom-Prop P P') (H : (h ∘ f) ~ f') →
  ((l : Level) → is-propositional-truncation l P' f') →
  is-equiv h →
  ((l : Level) → is-propositional-truncation l P f)
is-ptruncation-is-equiv-is-ptruncation P P' f f' h H is-ptr-f' is-equiv-h l Q =
  is-equiv-left-factor
    ( precomp-Prop P' f' Q)
    ( precomp-Prop P f Q)
    ( precomp h (type-Prop Q))
    ( triangle-3-for-2-is-ptruncation P P' f f' h H Q)
    ( is-ptr-f' l Q)
    ( is-equiv-precomp-is-equiv h is-equiv-h (type-Prop Q))

-- Corollary 13.1.6

is-uniquely-unique-propositional-truncation :
  {l1 l2 l3 : Level} {A : UU l1} (P : UU-Prop l2) (P' : UU-Prop l3)
  (f : A → type-Prop P) (f' : A → type-Prop P') →
  ({l : Level} → is-propositional-truncation l P f) →
  ({l : Level} → is-propositional-truncation l P' f') →
  is-contr (Σ (equiv-Prop P P') (λ e → (map-equiv e ∘ f) ~ f'))
is-uniquely-unique-propositional-truncation P P' f f' is-ptr-f is-ptr-f' =
  is-contr-total-Eq-substructure
    ( universal-property-is-propositional-truncation _ P f is-ptr-f P' f')
    ( is-subtype-is-equiv)
    ( map-is-propositional-truncation P f is-ptr-f P' f')
    ( htpy-is-propositional-truncation P f is-ptr-f P' f')
    ( is-equiv-is-ptruncation-is-ptruncation  P P' f f'
      ( map-is-propositional-truncation P f is-ptr-f P' f')
      ( htpy-is-propositional-truncation P f is-ptr-f P' f')
      ( λ l → is-ptr-f)
      ( λ l → is-ptr-f'))

-- Axiom 13.1.8

postulate type-trunc-Prop : {l : Level} → UU l → UU l

postulate is-prop-type-trunc-Prop : {l : Level} (A : UU l) → is-prop (type-trunc-Prop A)

trunc-Prop : {l : Level} → UU l → UU-Prop l
trunc-Prop A = pair (type-trunc-Prop A) (is-prop-type-trunc-Prop A)

postulate unit-trunc-Prop : {l : Level} (A : UU l) → A → type-Prop (trunc-Prop A)

postulate is-propositional-truncation-trunc-Prop : {l1 l2 : Level} (A : UU l1) → is-propositional-truncation l2 (trunc-Prop A) (unit-trunc-Prop A)

universal-property-trunc-Prop : {l1 l2 : Level} (A : UU l1) →
  universal-property-propositional-truncation l2
    ( trunc-Prop A)
    ( unit-trunc-Prop A)
universal-property-trunc-Prop A =
  universal-property-is-propositional-truncation _
    ( trunc-Prop A)
    ( unit-trunc-Prop A)
    ( is-propositional-truncation-trunc-Prop A)

map-universal-property-trunc-Prop :
  {l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) →
  (A → type-Prop P) → type-hom-Prop (trunc-Prop A) P
map-universal-property-trunc-Prop {A = A} P f =
  map-is-propositional-truncation
    ( trunc-Prop A)
    ( unit-trunc-Prop A)
    ( is-propositional-truncation-trunc-Prop A)
    ( P)
    ( f) 

-- Proposition 13.1.9

unique-functor-trunc-Prop :
  {l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  is-contr
    ( Σ ( type-hom-Prop (trunc-Prop A) (trunc-Prop B))
        ( λ h → (h ∘ (unit-trunc-Prop A)) ~ ((unit-trunc-Prop B) ∘ f)))
unique-functor-trunc-Prop {l1} {l2} {A} {B} f =
  universal-property-trunc-Prop A (trunc-Prop B) ((unit-trunc-Prop B) ∘ f)

functor-trunc-Prop :
  {l1 l2 : Level} {A : UU l1} {B : UU l2} →
  (A → B) → type-hom-Prop (trunc-Prop A) (trunc-Prop B)
functor-trunc-Prop f =
  pr1 (center (unique-functor-trunc-Prop f))

htpy-functor-trunc-Prop :
  { l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  ( (functor-trunc-Prop f) ∘ (unit-trunc-Prop A)) ~ ((unit-trunc-Prop B) ∘ f)
htpy-functor-trunc-Prop f =
  pr2 (center (unique-functor-trunc-Prop f))

htpy-uniqueness-functor-trunc-Prop :
  { l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  ( h : type-hom-Prop (trunc-Prop A) (trunc-Prop B)) →
  ( ( h ∘ (unit-trunc-Prop A)) ~ ((unit-trunc-Prop B) ∘ f)) →
  (functor-trunc-Prop f) ~ h
htpy-uniqueness-functor-trunc-Prop f h H =
  htpy-eq (ap pr1 (contraction (unique-functor-trunc-Prop f) (pair h H)))

id-functor-trunc-Prop :
  { l1 : Level} {A : UU l1} → functor-trunc-Prop (id {A = A}) ~ id
id-functor-trunc-Prop {l1} {A} =
  htpy-uniqueness-functor-trunc-Prop id id refl-htpy

comp-functor-trunc-Prop :
  { l1 l2 l3 : Level} {A : UU l1} {B : UU l2} {C : UU l3}
  ( g : B → C) (f : A → B) →
  ( functor-trunc-Prop (g ∘ f)) ~
  ( (functor-trunc-Prop g) ∘ (functor-trunc-Prop f))
comp-functor-trunc-Prop g f =
  htpy-uniqueness-functor-trunc-Prop
    ( g ∘ f)
    ( (functor-trunc-Prop g) ∘ (functor-trunc-Prop f))
    ( ( (functor-trunc-Prop g) ·l (htpy-functor-trunc-Prop f)) ∙h
      ( ( htpy-functor-trunc-Prop g) ·r f))

--------------------------------------------------------------------------------

-- Section 13.2 The dependent universal property of the propositional
-- truncations

-- Definition 13.2.1

dependent-universal-property-propositional-truncation :
  ( l : Level) {l1 l2 : Level} {A : UU l1}
  ( P : UU-Prop l2) (f : A → type-Prop P) → UU (lsuc l ⊔ l1 ⊔ l2)
dependent-universal-property-propositional-truncation l {l1} {l2} {A} P f =
  ( Q : type-Prop P → UU-Prop l) → is-equiv (precomp-Π f (type-Prop ∘ Q))

-- Theorem 13.2.2

abstract
  dependent-universal-property-is-propositional-truncation :
    { l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
    ( {l : Level} → is-propositional-truncation l P f) →
    ( {l : Level} → dependent-universal-property-propositional-truncation l P f)
  dependent-universal-property-is-propositional-truncation
    {l1} {l2} {A} P f is-ptr-f Q =
    is-fiberwise-equiv-is-equiv-toto-is-equiv-base-map
      ( λ (g : A → type-Prop P) → (x : A) → type-Prop (Q (g x)))
      ( precomp f (type-Prop P))
      ( λ h → precomp-Π f (λ p → type-Prop (Q (h p))))
      ( is-ptr-f P)
      ( is-equiv-top-is-equiv-bottom-square
        ( inv-choice-∞
          { C = λ (x : type-Prop P) (p : type-Prop P) → type-Prop (Q p)})
        ( inv-choice-∞
          { C = λ (x : A) (p : type-Prop P) → type-Prop (Q p)})
        ( toto
          ( λ (g : A → type-Prop P) → (x : A) → type-Prop (Q (g x)))
          ( precomp f (type-Prop P))
          ( λ h → precomp-Π f (λ p → type-Prop (Q (h p)))))
        ( precomp f (Σ (type-Prop P) (λ p → type-Prop (Q p))))
        ( ind-Σ (λ h h' → refl))
        ( is-equiv-inv-choice-∞)
        ( is-equiv-inv-choice-∞)
        ( is-ptr-f (Σ-Prop P Q)))
      ( id {A = type-Prop P})

dependent-universal-property-trunc-Prop :
  {l l1 : Level} (A : UU l1) →
  dependent-universal-property-propositional-truncation l
    ( trunc-Prop A)
    ( unit-trunc-Prop A)
dependent-universal-property-trunc-Prop A =
  dependent-universal-property-is-propositional-truncation
    ( trunc-Prop A)
    ( unit-trunc-Prop A)
    ( is-propositional-truncation-trunc-Prop A)

abstract
  is-propositional-truncation-dependent-universal-property :
    { l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
    ( {l : Level} →
      dependent-universal-property-propositional-truncation l P f) →
    ( {l : Level} → is-propositional-truncation l P f)
  is-propositional-truncation-dependent-universal-property P f dup-f Q =
    dup-f (λ p → Q)

--------------------------------------------------------------------------------

-- Section 13.3 Propositional truncations as higher inductive types

-- Definition 13.3.1

case-paths-induction-principle-propositional-truncation :
  { l : Level} {l1 l2 : Level} {A : UU l1}
  ( P : UU-Prop l2) (α : (p q : type-Prop P) → Id p q) (f : A → type-Prop P) →
  ( B : type-Prop P → UU l) → UU (l ⊔ l2)
case-paths-induction-principle-propositional-truncation P α f B =
  (p q : type-Prop P) (x : B p) (y : B q) → Id (tr B (α p q) x) y
  
induction-principle-propositional-truncation :
  (l : Level) {l1 l2 : Level} {A : UU l1}
  (P : UU-Prop l2) (α : (p q : type-Prop P) → Id p q) (f : A → type-Prop P) →
  UU (lsuc l ⊔ l1 ⊔ l2)
induction-principle-propositional-truncation l {l1} {l2} {A} P α f =
  ( B : type-Prop P → UU l) →
  ( g : (x : A) → (B (f x))) →
  ( β : case-paths-induction-principle-propositional-truncation P α f B) →
  Σ ((p : type-Prop P) → B p) (λ h → (x : A) → Id (h (f x)) (g x))

-- Lemma 13.3.2

is-prop-case-paths-induction-principle-propositional-truncation :
  { l : Level} {l1 l2 : Level} {A : UU l1}
  ( P : UU-Prop l2) (α : (p q : type-Prop P) → Id p q) (f : A → type-Prop P) →
  ( B : type-Prop P → UU l) →
  case-paths-induction-principle-propositional-truncation P α f B →
  ( p : type-Prop P) → is-prop (B p)
is-prop-case-paths-induction-principle-propositional-truncation P α f B β p =
  is-prop-is-contr-if-inh (λ x → pair (tr B (α p p) x) (β p p x))

case-paths-induction-principle-propositional-truncation-is-prop :
  { l : Level} {l1 l2 : Level} {A : UU l1}
  ( P : UU-Prop l2) (α : (p q : type-Prop P) → Id p q) (f : A → type-Prop P) →
  ( B : type-Prop P → UU l) →
  ( (p : type-Prop P) → is-prop (B p)) →
  case-paths-induction-principle-propositional-truncation P α f B
case-paths-induction-principle-propositional-truncation-is-prop
  P α f B is-prop-B p q x y =
  eq-is-prop (is-prop-B q) (tr B (α p q) x) y

-- Theorem 13.2.3

abstract
  induction-principle-dependent-universal-property-propositional-truncation :
    { l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
    ( {l : Level} →
      dependent-universal-property-propositional-truncation l P f) →
    ( {l : Level} → induction-principle-propositional-truncation l P
      ( eq-is-prop (is-prop-type-Prop P)) f)
  induction-principle-dependent-universal-property-propositional-truncation
    P f dup-f B g α =
    tot
      ( λ h → htpy-eq)
      ( center
        ( is-contr-map-is-equiv
          ( dup-f
            ( λ p →
              pair
                ( B p)
                ( is-prop-case-paths-induction-principle-propositional-truncation
                  ( P)
                  ( eq-is-prop (is-prop-type-Prop P))
                  f B α p)))
          ( g)))

abstract
  dependent-universal-property-induction-principle-propositional-truncation :
    { l1 l2 : Level} {A : UU l1} (P : UU-Prop l2) (f : A → type-Prop P) →
    ( {l : Level} → induction-principle-propositional-truncation l P
      ( eq-is-prop (is-prop-type-Prop P)) f) →
    ( {l : Level} → dependent-universal-property-propositional-truncation l P f)
  dependent-universal-property-induction-principle-propositional-truncation
    P f ind-f Q =
    is-equiv-is-prop
      ( is-prop-Π (λ p → is-prop-type-Prop (Q p)))
      ( is-prop-Π (λ a → is-prop-type-Prop (Q (f a))))
      ( λ g →
        pr1
          ( ind-f
            ( λ p → type-Prop (Q p))
            ( g)
            ( case-paths-induction-principle-propositional-truncation-is-prop
              ( P)
              ( eq-is-prop (is-prop-type-Prop P))
              ( f)
              ( λ p → type-Prop (Q p))
              ( λ p → is-prop-type-Prop (Q p)))))

--------------------------------------------------------------------------------

-- Section 13.4 The image of a map

--------------------------------------------------------------------------------

-- The universal property of the image

-- Definition 13.4.1

-- We introduce the image inclusion of a map.

comp-hom-slice :
  {l1 l2 l3 l4 : Level} {X : UU l1} {A : UU l2} {B : UU l3} {C : UU l4}
  (f : A → X) (g : B → X) (h : C → X) →
  hom-slice g h → hom-slice f g → hom-slice f h
comp-hom-slice f g h j i =
  pair ( ( map-hom-slice g h j) ∘
         ( map-hom-slice f g i))
       ( ( triangle-hom-slice f g i) ∙h
         ( (triangle-hom-slice g h j) ·r (map-hom-slice f g i)))

id-hom-slice :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) → hom-slice f f
id-hom-slice f = pair id refl-htpy

is-equiv-hom-slice :
  {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} {B : UU l3}
  (f : A → X) (g : B → X) → hom-slice f g → UU (l2 ⊔ l3)
is-equiv-hom-slice f g h = is-equiv (map-hom-slice f g h)

-- Definition 13.4.2

precomp-emb :
  { l1 l2 l3 l4 : Level} {X : UU l1} {A : UU l2} (f : A → X)
  {B : UU l3} ( i : B ↪ X) (q : hom-slice f (map-emb i)) →
  {C : UU l4} ( j : C ↪ X) (r : hom-slice (map-emb i) (map-emb j)) →
  hom-slice f (map-emb j)
precomp-emb f i q j r =
  pair
    ( ( map-hom-slice (map-emb i) (map-emb j) r) ∘
      ( map-hom-slice f (map-emb i) q))
    ( ( triangle-hom-slice f (map-emb i) q) ∙h
      ( ( triangle-hom-slice (map-emb i) (map-emb j) r) ·r
        ( map-hom-slice f (map-emb i) q)))

universal-property-image :
  ( l : Level) {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  { B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i)) →
  UU (lsuc l ⊔ l1 ⊔ l2 ⊔ l3)
universal-property-image l {X = X} f i q =
  ( C : UU l) (j : C ↪ X) → is-equiv (precomp-emb f i q j)

-- Lemma 13.4.3

is-prop-hom-slice :
  { l1 l2 l3 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  { B : UU l3} (i : B ↪ X) → is-prop (hom-slice f (map-emb i))
is-prop-hom-slice {X = X} f i =
  is-prop-is-equiv
    ( (x : X) → fib f x → fib (map-emb i) x)
    ( fiberwise-hom-hom-slice f (map-emb i))
    ( is-equiv-fiberwise-hom-hom-slice f (map-emb i))
    ( is-prop-Π
      ( λ x → is-prop-Π
        ( λ p → is-prop-map-is-emb (map-emb i) (is-emb-map-emb i) x)))

-- Proposition 13.4.4

-- Proposition 13.4.4 condition (ii)

universal-property-image' :
  ( l : Level) {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  { B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i)) →
  UU (lsuc l ⊔ l1 ⊔ l2 ⊔ l3)
universal-property-image' l {X = X} f i q =
  ( C : UU l) (j : C ↪ X) →
    hom-slice f (map-emb j) → hom-slice (map-emb i) (map-emb j)

{- We show that condition (ii) implies the universal property of the image
   inclusion. The other direction of the equivalence is trivial and never 
   needed. -}

universal-property-image-universal-property-image' :
  ( l : Level) {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  { B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i)) →
  universal-property-image' l f i q → universal-property-image l f i q
universal-property-image-universal-property-image' l f i q up' C j =
  is-equiv-is-prop
    ( is-prop-hom-slice (map-emb i) j)
    ( is-prop-hom-slice f j)
    ( up' C j)

-- Example 13.4.5

universal-property-image-has-section :
  (l : Level) {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  sec f → universal-property-image l f emb-id (pair f refl-htpy)
universal-property-image-has-section l f (pair g H) =
  universal-property-image-universal-property-image'
    l f emb-id (pair f refl-htpy)
    ( λ B m h → pair ((pr1 h) ∘ g) ( λ x → (inv (H x)) ∙ (pr2 h (g x))))

universal-property-image-is-emb :
  (l : Level) {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  (H : is-emb f) → universal-property-image l f (pair f H) (pair id refl-htpy)
universal-property-image-is-emb l f H =
  universal-property-image-universal-property-image'
    l f (pair f H) (pair id refl-htpy)
    ( λ B m h → h)

-- Example 13.4.6

{- We show that a map A → P into a proposition P is a propositional truncation
   if and only if P is the image of A in 1. -}

--------------------------------------------------------------------------------

-- The existence of the image

-- Definition 13.4.7

im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) → UU (l1 ⊔ l2)
im {X = X} {A} f = Σ X (λ x → type-trunc-Prop (fib f x))

inclusion-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) → im f → X
inclusion-im f = pr1

map-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) → A → im f
map-im f a = pair (f a) (unit-trunc-Prop (fib f (f a)) (pair a refl))

triangle-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  f ~ (inclusion-im f ∘ map-im f)
triangle-im f a = refl

hom-slice-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  hom-slice f (inclusion-im f)
hom-slice-im f = pair (map-im f) (triangle-im f)

-- Proposition 13.4.8

is-emb-inclusion-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  is-emb (inclusion-im f)
is-emb-inclusion-im f =
  is-emb-pr1-is-subtype (λ x → is-prop-type-trunc-Prop (fib f x))

emb-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) → im f ↪ X
emb-im f = pair (inclusion-im f) (is-emb-inclusion-im f)

-- Theorem 13.4.9

fiberwise-map-universal-property-im :
  {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} {B : UU l3} (f : A → X) →
  (m : B ↪ X) (h : hom-slice f (map-emb m)) →
  (x : X) → type-trunc-Prop (fib f x) → fib (map-emb m) x
fiberwise-map-universal-property-im f m h x =
  map-universal-property-trunc-Prop
    { A = (fib f x)}
    ( fib-prop-emb m x)
    ( λ t →
      pair ( map-hom-slice f (map-emb m) h (pr1 t))
           ( ( inv (triangle-hom-slice f (map-emb m) h (pr1 t))) ∙
             ( pr2 t)))

map-universal-property-im :
  {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} {B : UU l3} (f : A → X) →
  (m : B ↪ X) (h : hom-slice f (map-emb m)) → im f → B
map-universal-property-im f m h (pair x t) =
  pr1 (fiberwise-map-universal-property-im f m h x t)

triangle-universal-property-im :
  {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} {B : UU l3} (f : A → X) →
  (m : B ↪ X) (h : hom-slice f (map-emb m)) →
  inclusion-im f ~ ((map-emb m) ∘ (map-universal-property-im f m h))
triangle-universal-property-im f m h (pair x t) =
  inv (pr2 (fiberwise-map-universal-property-im f m h x t))

universal-property-im :
  (l : Level) {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  universal-property-image l f (emb-im f) (hom-slice-im f)
universal-property-im l f =
  universal-property-image-universal-property-image'
    l f (emb-im f) (hom-slice-im f)
    ( λ B m h →
      pair ( map-universal-property-im f m h)
           ( triangle-universal-property-im f m h))

{- We show some truncatedness results, so that we can use images as sets, and
   so on. -}

is-trunc-im :
  {l1 l2 : Level} (k : 𝕋) {X : UU l1} {A : UU l2} (f : A → X) →
  is-trunc (succ-𝕋 k) X → is-trunc (succ-𝕋 k) (im f)
is-trunc-im k f = is-trunc-emb k (emb-im f) 

is-prop-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  is-prop X → is-prop (im f)
is-prop-im = is-trunc-im neg-two-𝕋

is-set-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  is-set X → is-set (im f)
is-set-im = is-trunc-im neg-one-𝕋

is-1-type-im :
  {l1 l2 : Level} {X : UU l1} {A : UU l2} (f : A → X) →
  is-1-type X → is-1-type (im f)
is-1-type-im = is-trunc-im zero-𝕋

im-Set' :
  {l1 l2 : Level} (A : UU l2) (X : UU-Set l1) (f : A → type-Set X) →
  UU-Set (l1 ⊔ l2)
im-Set' A X f = pair (im f) (is-set-im f (is-set-type-Set X))

im-Set :
  {l1 l2 : Level} (A : UU-Set l2) (X : UU-Set l1) (f : type-hom-Set A X) →
  UU-Set (l1 ⊔ l2)
im-Set A = im-Set' (type-Set A)

im-1-Type' :
  {l1 l2 : Level} (A : UU l2) (X : UU-1-Type l1)
  (f : A → type-1-Type X) → UU-1-Type (l1 ⊔ l2)
im-1-Type' A X f = pair (im f) (is-1-type-im f (is-1-type-type-1-Type X))

im-1-Type :
  {l1 l2 : Level} (A : UU-1-Type l2) (X : UU-1-Type l1)
  (f : type-hom-1-Type A X) → UU-1-Type (l1 ⊔ l2)
im-1-Type A = im-1-Type' (type-1-Type A)

--------------------------------------------------------------------------------

-- The uniqueness of the image

-- Proposition 13.4.10

is-equiv-hom-slice-emb :
  {l1 l2 l3 : Level} {X : UU l1} {A : UU l2} {B : UU l3}
  (f : A ↪ X) (g : B ↪ X) (h : hom-slice (map-emb f) (map-emb g)) →
  hom-slice (map-emb g) (map-emb f) →
  is-equiv-hom-slice (map-emb f) (map-emb g) h
is-equiv-hom-slice-emb f g h i =
  is-equiv-has-inverse
    ( map-hom-slice (map-emb g) (map-emb f) i)
    ( λ y →
      eq-emb g
      ( inv
        ( ( triangle-hom-slice
            ( map-emb g)
            ( map-emb f)
            ( i)
            ( y)) ∙
          ( triangle-hom-slice
            ( map-emb f)
            ( map-emb g)
            ( h)
            ( map-hom-slice (map-emb g) (map-emb f) i y)))))
    ( λ x →
      eq-emb f
      ( inv
        ( ( triangle-hom-slice (map-emb f) (map-emb g) h x) ∙
          ( triangle-hom-slice (map-emb g) (map-emb f) i
            ( map-hom-slice
              ( map-emb f)
              ( map-emb g)
              ( h)
              ( x))))))

is-equiv-up-image-up-image :
  {l1 l2 l3 l4 : Level} {X : UU l1} {A : UU l2} (f : A → X)
  {B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i))
  {B' : UU l4} (i' : B' ↪ X) (q' : hom-slice f (map-emb i'))
  (h : hom-slice (map-emb i) (map-emb i'))
  (p : Id (comp-hom-slice f (map-emb i) (map-emb i') h q) q') →
  ({l : Level} → universal-property-image l f i q) →
  ({l : Level} → universal-property-image l f i' q') →
  is-equiv (map-hom-slice (map-emb i) (map-emb i') h)
is-equiv-up-image-up-image f i q i' q' h p up-i up-i' =
  is-equiv-hom-slice-emb i i' h (inv-is-equiv (up-i' _ i) q)

up-image-up-image-is-equiv :
  {l1 l2 l3 l4 : Level} {X : UU l1} {A : UU l2} (f : A → X)
  {B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i))
  {B' : UU l4} (i' : B' ↪ X) (q' : hom-slice f (map-emb i'))
  (h : hom-slice (map-emb i) (map-emb i'))
  (p : Id (comp-hom-slice f (map-emb i) (map-emb i') h q) q') →
  is-equiv (map-hom-slice (map-emb i) (map-emb i') h) →
  ({l : Level} → universal-property-image l f i q) →
  ({l : Level} → universal-property-image l f i' q')
up-image-up-image-is-equiv f i q i' q' h p is-equiv-h up-i {l} =
  universal-property-image-universal-property-image' l f i' q'
    ( λ C j r →
      comp-hom-slice
        ( map-emb i')
        ( map-emb i)
        ( map-emb j)
        ( inv-is-equiv (up-i C j) r)
        ( pair
          ( inv-is-equiv is-equiv-h)
          ( triangle-section
            ( map-emb i)
            ( map-emb i')
            ( map-hom-slice (map-emb i) (map-emb i') h)
            ( triangle-hom-slice (map-emb i) (map-emb i') h)
            ( pair ( inv-is-equiv is-equiv-h)
                   ( issec-inv-is-equiv is-equiv-h)))))

up-image-is-equiv-up-image :
  {l1 l2 l3 l4 : Level} {X : UU l1} {A : UU l2} (f : A → X)
  {B : UU l3} (i : B ↪ X) (q : hom-slice f (map-emb i))
  {B' : UU l4} (i' : B' ↪ X) (q' : hom-slice f (map-emb i'))
  (h : hom-slice (map-emb i) (map-emb i'))
  (p : Id (comp-hom-slice f (map-emb i) (map-emb i') h q) q') →
  ({l : Level} → universal-property-image l f i' q') →
  is-equiv (map-hom-slice (map-emb i) (map-emb i') h) →
  ({l : Level} → universal-property-image l f i q)
up-image-is-equiv-up-image f i q i' q' h p up-i' is-equiv-h {l} =
  universal-property-image-universal-property-image' l f i q
    ( λ C j r →
      comp-hom-slice
        ( map-emb i)
        ( map-emb i')
        ( map-emb j)
        ( inv-is-equiv (up-i' C j) r)
        ( h))

--------------------------------------------------------------------------------

-- Section 13.5 Surjective maps

-- Definition 13.5.1

is-surjective :
  {l1 l2 : Level} {A : UU l1} {B : UU l2} → (A → B) → UU (l1 ⊔ l2)
is-surjective {B = B} f = (y : B) → type-trunc-Prop (fib f y)

-- Example 13.5.2

-- Proposition 13.5.3

dependent-universal-property-surj :
  (l : Level) {l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  UU ((lsuc l) ⊔ l1 ⊔ l2)
dependent-universal-property-surj l {B = B} f =
  (P : B → UU-Prop l) →
    is-equiv (λ (h : (b : B) → type-Prop (P b)) x → h (f x))

is-surjective-dependent-universal-property-surj :
  {l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  ({l : Level} → dependent-universal-property-surj l f) →
  is-surjective f
is-surjective-dependent-universal-property-surj f dup-surj-f =
  inv-is-equiv
    ( dup-surj-f (λ b → trunc-Prop (fib f b)))
    ( λ x → unit-trunc-Prop (fib f (f x)) (pair x refl))

square-dependent-universal-property-surj :
  {l1 l2 l3 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  (P : B → UU-Prop l3) →
  ( λ (h : (y : B) → type-Prop (P y)) x → h (f x)) ~
  ( ( λ h x → h (f x) (pair x refl)) ∘
    ( ( λ h y → (h y) ∘ (unit-trunc-Prop (fib f y))) ∘
      ( λ h y → const (type-trunc-Prop (fib f y)) (type-Prop (P y)) (h y))))
square-dependent-universal-property-surj f P = refl-htpy

dependent-universal-property-surj-is-surjective :
  {l1 l2 : Level} {A : UU l1} {B : UU l2} (f : A → B) →
  is-surjective f →
  ({l : Level} → dependent-universal-property-surj l f)
dependent-universal-property-surj-is-surjective f is-surj-f P =
  is-equiv-comp'
    ( λ h x → h (f x) (pair x refl))
    ( ( λ h y → (h y) ∘ (unit-trunc-Prop (fib f y))) ∘
      ( λ h y → const (type-trunc-Prop (fib f y)) (type-Prop (P y)) (h y)))
    ( is-equiv-comp'
      ( λ h y → (h y) ∘ (unit-trunc-Prop (fib f y)))
      ( λ h y → const (type-trunc-Prop (fib f y)) (type-Prop (P y)) (h y))
      ( is-equiv-postcomp-Π
        ( λ y p z → p)
        ( λ y →
          is-equiv-diagonal-is-contr
            ( is-surj-f y)
            ( is-contr-is-prop-inh
              ( is-prop-type-trunc-Prop (fib f y))
              ( is-surj-f y))
            ( type-Prop (P y))))
      ( is-equiv-postcomp-Π
        ( λ b g → g ∘ (unit-trunc-Prop (fib f b)))
        ( λ b → is-propositional-truncation-trunc-Prop (fib f b) (P b))))
    ( is-equiv-map-reduce-Π-fib f ( λ y z → type-Prop (P y)))

-- Corollary 13.5.4

is-surjective-is-propositional-truncation :
  {l1 l2 : Level} {A : UU l1} {P : UU-Prop l2} (f : A → type-Prop P) →
    ({l : Level} → dependent-universal-property-propositional-truncation l P f) → is-surjective f
is-surjective-is-propositional-truncation f duppt-f =
  is-surjective-dependent-universal-property-surj f duppt-f

is-propsitional-truncation-is-surjective :
  {l1 l2 : Level} {A : UU l1} {P : UU-Prop l2} (f : A → type-Prop P) →
    is-surjective f → {l : Level} → dependent-universal-property-propositional-truncation l P f
is-propsitional-truncation-is-surjective f is-surj-f =
  dependent-universal-property-surj-is-surjective f is-surj-f

-- Theorem 13.5.5

{-
is-surjective-universal-property-image :
  {l1 l2 l3 : Level} {A : UU l1} {B : UU l2} {X : UU l3}
  (f : A → X) (i : B ↪ X) (q : hom-slice f (map-emb i)) →
  ({l : Level} → universal-property-image l f i q) →
  is-surjective (map-hom-slice f (map-emb i) q)
is-surjective-universal-property-image f i q up-i b = {!!}
-}

--------------------------------------------------------------------------------

-- Section 13.6 Cantor's diagonal argument

-- Definition 13.6.1

-- Theorem 13.6.2

map-cantor :
  {l1 l2 : Level} (X : UU l1) (f : X → (X → UU-Prop l2)) → (X → UU-Prop l2)
map-cantor X f x = neg-Prop (f x x)

iff-eq :
  {l1 : Level} {P Q : UU-Prop l1} → Id P Q → P ⇔ Q
iff-eq refl = pair id id

no-fixed-points-neg-Prop :
  {l1 : Level} (P : UU-Prop l1) → ¬ (P ⇔ neg-Prop P)
no-fixed-points-neg-Prop P = no-fixed-points-neg (type-Prop P)

not-in-image-map-cantor :
  {l1 l2 : Level} (X : UU l1) (f : X → (X → UU-Prop l2)) →
  ( t : fib f (map-cantor X f)) → empty
not-in-image-map-cantor X f (pair x α) =
  no-fixed-points-neg-Prop (f x x) (iff-eq (htpy-eq α x))

cantor : {l1 l2 : Level} (X : UU l1) (f : X → (X → UU-Prop l2)) →
  ¬ (is-surjective f)
cantor X f H =
  ( map-universal-property-trunc-Prop empty-Prop
    ( not-in-image-map-cantor X f)
    ( H (map-cantor X f)))

--------------------------------------------------------------------------------

-- Section 13.7 Logic in type theory

-- Definition

conj-Prop = prod-Prop

type-conj-Prop :
  {l1 l2 : Level} → UU-Prop l1 → UU-Prop l2 → UU (l1 ⊔ l2)
type-conj-Prop P Q = type-Prop (conj-Prop P Q)

disj-Prop :
  {l1 l2 : Level} → UU-Prop l1 → UU-Prop l2 → UU-Prop (l1 ⊔ l2)
disj-Prop P Q = trunc-Prop (coprod (type-Prop P) (type-Prop Q))

type-disj-Prop :
  {l1 l2 : Level} → UU-Prop l1 → UU-Prop l2 → UU (l1 ⊔ l2)
type-disj-Prop P Q = type-Prop (disj-Prop P Q)

inl-disj-Prop :
  {l1 l2 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) →
  type-hom-Prop P (disj-Prop P Q)
inl-disj-Prop P Q =
  (unit-trunc-Prop (coprod (type-Prop P) (type-Prop Q))) ∘ inl

inr-disj-Prop :
  {l1 l2 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) →
  type-hom-Prop Q (disj-Prop P Q)
inr-disj-Prop P Q =
  (unit-trunc-Prop (coprod (type-Prop P) (type-Prop Q))) ∘ inr

-- Proposition

ev-disj-Prop :
  {l1 l2 l3 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) (R : UU-Prop l3) →
  type-hom-Prop
    ( hom-Prop (disj-Prop P Q) R)
    ( conj-Prop (hom-Prop P R) (hom-Prop Q R))
ev-disj-Prop P Q R h =
  pair (h ∘ (inl-disj-Prop P Q)) (h ∘ (inr-disj-Prop P Q))

inv-ev-disj-Prop :
  {l1 l2 l3 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) (R : UU-Prop l3) →
  type-hom-Prop
    ( conj-Prop (hom-Prop P R) (hom-Prop Q R))
    ( hom-Prop (disj-Prop P Q) R)
inv-ev-disj-Prop P Q R (pair f g) =
  map-universal-property-trunc-Prop R (ind-coprod (λ t → type-Prop R) f g)

is-equiv-ev-disj-Prop :
  {l1 l2 l3 : Level} (P : UU-Prop l1) (Q : UU-Prop l2) (R : UU-Prop l3) →
  is-equiv (ev-disj-Prop P Q R)
is-equiv-ev-disj-Prop P Q R =
  is-equiv-is-prop
    ( is-prop-type-Prop (hom-Prop (disj-Prop P Q) R))
    ( is-prop-type-Prop (conj-Prop (hom-Prop P R) (hom-Prop Q R)))
    ( inv-ev-disj-Prop P Q R)

-- Definition

exists-Prop :
  {l1 l2 : Level} {A : UU l1} (P : A → UU-Prop l2) → UU-Prop (l1 ⊔ l2)
exists-Prop {l1} {l2} {A} P = trunc-Prop (Σ A (λ x → type-Prop (P x)))

exists :
  {l1 l2 : Level} {A : UU l1} (P : A → UU-Prop l2) → UU (l1 ⊔ l2)
exists P = type-Prop (exists-Prop P)

is-prop-exists :
  {l1 l2 : Level} {A : UU l1} (P : A → UU-Prop l2) → is-prop (exists P)
is-prop-exists P = is-prop-type-Prop (exists-Prop P)

intro-exists-Prop :
  {l1 l2 : Level} {A : UU l1} (P : A → UU-Prop l2) →
  (x : A) → type-Prop (P x) → exists P
intro-exists-Prop {A = A} P x p =
  unit-trunc-Prop (Σ A (λ x → type-Prop (P x))) (pair x p)

-- Proposition

ev-intro-exists-Prop :
  {l1 l2 l3 : Level} {A : UU l1} (P : A → UU-Prop l2) (Q : UU-Prop l3) →
  type-hom-Prop (exists-Prop P) Q → (x : A) → type-hom-Prop (P x) Q
ev-intro-exists-Prop P Q H x p = H (intro-exists-Prop P x p)

elim-exists-Prop :
  {l1 l2 l3 : Level} {A : UU l1} (P : A → UU-Prop l2) (Q : UU-Prop l3) →
  ((x : A) → type-hom-Prop (P x) Q) → type-hom-Prop (exists-Prop P) Q
elim-exists-Prop {A = A} P Q f =
  map-universal-property-trunc-Prop Q (ind-Σ f)

is-equiv-ev-intro-exists-Prop :
  {l1 l2 l3 : Level} {A : UU l1} (P : A → UU-Prop l2) (Q : UU-Prop l3) →
  is-equiv (ev-intro-exists-Prop P Q)
is-equiv-ev-intro-exists-Prop P Q =
  is-equiv-is-prop
    ( is-prop-type-hom-Prop (exists-Prop P) Q)
    ( is-prop-Π ((λ x → is-prop-type-hom-Prop (P x) Q)))
    ( elim-exists-Prop P Q)
