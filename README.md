# Lefschetz Thimble Plotter (Mathematica)

Flow-based Mathematica visualiser for Lefschetz thimbles and dual thimbles in 1D complex integrals (Picard–Lefschetz theory).

![Example thimble geometry](./images/thimbles_example.png)

## What this does

- Finds saddle points by solving \(W'(z)=0\).
- Traces thimbles and dual thimbles via holomorphic gradient flow.
- Optional speed-normalised flow prevents runaway for high-degree potentials (e.g. \(z^9\), \(z^{11}\)).

## Quick start

1. Open `src/thimble_plotter.wl` in Mathematica.
2. Set `p`, `deltaParam`, and `box` near the top of the file.
3. Evaluate the script.

See:
- `docs/maths.md` for the flow equations and thimble/dual definitions.
- `docs/GitHUBThimbles.pdf` for PDF-style notes.

## Notes / troubleshooting

- Assumes non-degenerate saddles (\(W''(z_\sigma)\neq 0\)).
- If arms “disappear”, enlarge `box` and/or set `useNormalisedFlow = True`.
- For higher-degree polynomials, use the normalised flow to avoid numerical blow-up.

## Repository layout

- `src/` — Wolfram/Mathematica source
- `docs/` — mathematical notes + PDF
- `images/` — screenshots for README

## Licence

MIT (see `LICENSE`).

