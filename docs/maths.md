\# Maths notes: Lefschetz thimbles in 1 complex dimension



This repo visualises Lefschetz thimbles and their duals for integrals of the form



&nbsp;   I = ∫\_Γ exp(-κ W(z)) dz,



where `W(z)` is holomorphic (complex analytic) and `κ` is a (typically large) complex parameter. The key point is that the \*geometry\* of the steepest-descent contours is controlled by the saddles of `W` and by the phase of `κ`.



---



\## 1. Saddles (critical points)



A saddle is any `zσ` solving



&nbsp;   W'(zσ) = 0.



We assume non-degeneracy:



&nbsp;   W''(zσ) ≠ 0.



These are the points around which steepest-descent/ascent manifolds are attached.



---



\## 2. Holomorphic gradient flow



Write `z(u) = x(u) + i y(u)` and define the (upward/downward) holomorphic gradient flow



&nbsp;   dz/du = ± conjugate( κ W'(z) ).



In this repo we take `κ = 1` by default, so the flow becomes



&nbsp;   dz/du = ± conjugate( W'(z) ).



This is exactly what the Mathematica code integrates (in x,y form).



\*\*Important:\*\* multiplying the RHS by any positive real function `g(z)>0` does not change the curves, only the parametrisation in `u`. That is why the “speed-normalised” flow used for high-degree potentials preserves the geometry.



---



\## 3. Constant-phase property (Im(κ W) is constant)



Along the flow we have



&nbsp;   d/du \[ κ W(z(u)) ] = κ W'(z) dz/du

&nbsp;                     = ± κ W'(z) conjugate( κ W'(z) )

&nbsp;                     = ± |κ W'(z)|^2  (a real number).



So:



\- `Im( κ W(z(u)) )` is constant along each flow line,

\- `Re( κ W(z(u)) )` is strictly monotone (increasing for `+`, decreasing for `-`).



This is the steepest-descent / stationary-phase condition in one line.



---



\## 4. Thimbles and dual thimbles



\- The \*\*thimble\*\* `Jσ` attached to `zσ` is the set of points that flow \*into\* the saddle under the \*\*downward\*\* flow (equivalently: points that originate at the saddle under the upward flow).

\- The \*\*dual thimble\*\* `Kσ` is defined by the opposite flow direction.



In practice (for plotting) we start near the saddle and integrate outward, because starting exactly at `zσ` would not move.



---



\## 5. Why two “arms” (±ε v)



Near a non-degenerate saddle,



&nbsp;   W(z) ≈ W(zσ) + (1/2) W''(zσ) (z - zσ)^2.



The constant-phase condition `Im(W)=const` gives two opposite directions through the saddle (a 1D manifold has two local branches). Numerically, we take



&nbsp;   z0± = zσ ± ε v,



and integrate both to draw the full curve.



---



\## 6. Local direction choice v



Write `λ = κ W''(zσ)` and choose `v` so that `λ v^2` is real. One convenient choice is



&nbsp;   v = exp( - i Arg(λ) / 2 ).



This is exactly what the script implements (with an extra phase shift for the dual).



---



\## 7. Why speed-normalising helps for high powers



For high-degree polynomials, `|W'(z)|` can grow like `|z|^p`, so the raw flow can reach very large `|z|` in a short `u` interval (sometimes effectively “blowing up” for plotting purposes).



The normalised flow used in the code is



&nbsp;   dz/du = ± conjugate(W'(z)) / (1 + |conjugate(W'(z))|),



which bounds the speed while keeping the same geometric curves (it is just a reparametrisation of `u`).



---



\## 8. Mapping to the code



\- `Saddles\[δ]` solves `W'(z)=0`.

\- `ManifoldArms\[zS,δ,...]` builds the two initial points `z0± = zS ± ε v`.

\- The ODE system is the real/imag parts of `dz/du = ± conjugate(W'(z))` (optionally normalised).

\- `ThimbleArms` and `DualArms` are thin wrappers that fix the sign / phase shift.





