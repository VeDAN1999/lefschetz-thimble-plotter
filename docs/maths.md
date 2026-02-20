# Maths notes: Lefschetz thimbles in 1 complex dimension

This repo visualises Lefschetz thimbles and their duals for integrals of the form
\[
I=\int_{\Gamma}\exp\!\big(-\kappa W(z)\big)\,\mathrm{d}z,
\]
where \(W(z)\) is holomorphic and \(\kappa\) is a (typically large) complex parameter.

The key point is that the geometry of the steepest-descent contours is controlled by the saddles of \(W\) and by the phase of \(\kappa\).

---

## 1. Saddles (critical points)

A saddle is any \(z_\sigma\) solving \(W'(z_\sigma)=0\). We assume non-degeneracy: \(W''(z_\sigma)\neq 0\).

---

## 2. Holomorphic gradient flow

Write \(z(u)=x(u)+iy(u)\). Define the (upward/downward) holomorphic gradient flow
\[
\frac{\mathrm{d}z}{\mathrm{d}u}=\pm \overline{\kappa W'(z)}.
\]
In this repo we take \(\kappa=1\) by default, so
\[
\frac{\mathrm{d}z}{\mathrm{d}u}=\pm \overline{W'(z)}.
\]

Reparametrisations: multiplying the RHS by any positive real function \(g(z)>0\) does not change the curves, only the parametrisation in \(u\). That is why the “speed-normalised” flow preserves geometry.

---

## 3. Constant-phase property

Along the flow,
\[
\frac{\mathrm{d}}{\mathrm{d}u}\big[\kappa W(z(u))\big]
= \kappa W'(z)\frac{\mathrm{d}z}{\mathrm{d}u}
= \pm \kappa W'(z)\overline{\kappa W'(z)}
= \pm |\kappa W'(z)|^2\in\mathbb{R}.
\]

So:
- \(\mathrm{Im}(\kappa W)\) is constant along each flow line,
- \(\mathrm{Re}(\kappa W)\) is strictly monotone (increasing for \(+\), decreasing for \(-\)).

---

## 4. Thimbles and dual thimbles

- The thimble \(J_\sigma\) attached to \(z_\sigma\) is the set of points that flow into the saddle under the downward flow (equivalently: points that originate at the saddle under the upward flow).
- The dual thimble \(K_\sigma\) is defined by the opposite flow direction.

For plotting, we start near the saddle and integrate outward, since starting exactly at \(z_\sigma\) does not move.

---

## 5. Why two arms (±ε v)

Near a non-degenerate saddle,
\[
W(z)\approx W(z_\sigma)+\tfrac12 W''(z_\sigma)(z-z_\sigma)^2.
\]
The constant-phase condition gives two opposite directions through the saddle. Numerically we take
\[
z_0^\pm=z_\sigma\pm \varepsilon v
\]
and integrate both arms.

---

## 6. Local direction choice v

Let \(\lambda=\kappa W''(z_\sigma)\) and choose \(v\) so that \(\lambda v^2\in\mathbb{R}\). One convenient choice is
\[
v=\exp\!\big(-\tfrac{i}{2}\mathrm{Arg}(\lambda)\big).
\]
This is what the script implements (with an extra phase shift for the dual).

---

## 7. Why speed-normalising helps

For high-degree polynomials, \(|W'(z)|\) grows fast and the raw flow can “blow up” in finite plotting time. The normalised flow used in the code is
\[
\frac{\mathrm{d}z}{\mathrm{d}u}=\pm \frac{\overline{W'(z)}}{1+|\overline{W'(z)}|},
\]
which bounds the speed while keeping the same geometric curves.

---

## 8. Mapping to the code

- `Saddles[δ]` solves `W'(z)=0`.
- `ManifoldArms[zS,δ,...]` builds the two initial points `z0± = zS ± ε v`.
- The ODE system is the real/imag parts of `dz/du = ± conjugate(W'(z))` (optionally normalised).
- `ThimbleArms` and `DualArms` fix the sign / phase shift.
