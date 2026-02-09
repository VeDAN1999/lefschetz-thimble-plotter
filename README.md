# lefschetz-thimble-plotter

Flow-based Mathematica visualiser for Lefschetz thimbles and dual thimbles in 1D complex integrals (Picard–Lefschetz theory).



!\[Example thimble geometry](images/thimbles\_example.png)



\## What this does

\- Finds saddle points by solving \\(W'(z)=0\\).

\- Traces thimbles and dual thimbles via holomorphic gradient flow.

\- Includes an optional speed-normalised flow to prevent runaway for high-degree potentials (e.g. \\(z^9\\), \\(z^{11}\\)).



\## Quick start

1\. Open `src/thimble\_plotter.wl` in Mathematica.

2\. Set `p`, `deltaParam`, and `box` near the top of the file.

3\. Evaluate the script.



\## Notes

\- Assumes non-degenerate saddles (\\(W''(z\_\\sigma)\\neq 0\\)).

\- If arms “disappear” for high powers, keep `useNormalisedFlow = True` and/or enlarge `box`.



\## Licence

MIT.



