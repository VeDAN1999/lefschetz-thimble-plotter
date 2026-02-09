(* ================================================================\
*)(*Lefschetz thimble plotter (1 complex \
variable)*)(*Flow-based:traces thimbles/dual-thimbles via holomorphic \
flow.*)(*This is my thesis-style plotting window+conventions.*)(* \
================================================================*)

ClearAll["Global`*"];

(*-------------------------User controls-------------------------*)

box = {{-5, 5}, {-5, 
    5}}; (*Global plot window (I used this in my thesis).Adjust to \
taste.*)

c = 0.07; (*Arbitrary scalar constant.This is just a demo family of \
potentials.*)

p = 7; (*Power in the polynomial term:6,7,9,11,... (higher and \
fractional p gets wild). My thesis used p = 4.*)

deltaParam = 
  Exp[I Pi]; (*Parameter to analytically continue (Arg[deltaParam] is \
what matters).*)

epsDefault = 10^-5;   (*tiny nudge away from the saddle*)
uMaxDefault = 80;      (*how far we integrate in flow-time u*)

useNormalisedFlow = True;
(*Key switch for high degrees:-False:raw flow \
dz/du=\[PlusMinus]Conj[W'(z)] (can blow up for \
z^9,z^11,...)-True:speed-limited flow (same curves,safer numerics)*)

(*----------------Potential and derivatives----------------------*)

(*We are thinking of an integral of the schematic form exp(-\[Kappa] \
W(z)) dz.For \[Kappa] real positive,it only rescales u (doesn't \
change the curve geometry).If \[Kappa] has a phase,it rotates the \
thimble condition (we can add that later).*)

W[z_, \[Delta]_] := -z^2/2 + c \[Delta] z^p/4;

(*Mathematica trick:differentiate wrt a dummy symbol \[Zeta],then \
substitute \[Zeta]->z.This avoids \[OpenCurlyDoubleQuote]D::ivar\
\[CloseCurlyDoubleQuote] when z is numeric/not a pure symbol.*)

Wp[z_, \[Delta]_] := (D[W[\[Zeta], \[Delta]], \[Zeta]] /. \[Zeta] -> 
     z);
Wpp[z_, \[Delta]_] := (D[
     W[\[Zeta], \[Delta]], {\[Zeta], 2}] /. \[Zeta] -> z);

(*----------------Saddles (critical points)----------------------*)

Saddles[\[Delta]_] := (z /. NSolve[Wp[z, \[Delta]] == 0, z]) // N;
(*NSolve is generally more robust for higher degree than Solve.
//N forces floating-point roots (good for plotting).*)

SelectSaddle[s_List] := First@SortBy[s, Abs];
(*Picks the saddle closest to the origin (smallest|z|).*)

(*----------------Manifold tracer (thimble/dual)----------------*)

(*\[OpenCurlyDoubleQuote]Arms\[CloseCurlyDoubleQuote]=the two \
opposite rays leaving the saddle.We need both,otherwise we only plot \
half of the manifold.*)
(*See GitHUB for more mathematical details on the following module*)
ManifoldArms[zS_, \[Delta]_, sign_ : +1, 
   phaseShift_ : 0, \[CurlyEpsilon]_ : epsDefault, 
   umax_ : uMaxDefault, plotStyle_ : Directive[Thick]] := 
  Module[{\[Lambda], v, z0a, z0b, flow, scale, eqs, solA, 
    solB},(*Local curvature at the saddle:\[Lambda]=
   W''(zS).*)\[Lambda] = N@Wpp[zS, \[Delta]];
   (*Local tangent direction.Choose v so that (\[Lambda] v^2) is real \
(constant-phase locally).phaseShift=Pi rotates by \[Pi]/2,
   which corresponds to the dual direction.*)
   v = N@Exp[-I (Arg[\[Lambda]] + phaseShift)/2];
   (*Two opposite nudges->
   two arms.Starting exactly at zS would not move. Linearisation. *)
   z0a = zS + \[CurlyEpsilon] v;
   z0b = zS - \[CurlyEpsilon] v;
   (*Flow field for exp(-W):dz/du=\[PlusMinus]Conjugate[
   W'(z)].Writing z(u)=x(u)+i y(u) gives x',y' as Re/Im of that.*)
   flow[x_, y_] := Conjugate[Wp[x + I y, \[Delta]]];
   (*Speed limiter (optional but VERY useful for z^9,
   z^11,...) and it seems to preserve geometry well : dividing by (1+|
   flow|) does NOT change the geometric curves,
   it only changes how fast we move along them in u.*)
   scale[x_, y_] := If[useNormalisedFlow, 1 + Abs[flow[x, y]], 1];
   (*ODE system+initial conditions+stop when leaving the plot window.*)
   eqs[x0_, 
     y0_] := {x'[u] == sign Re[flow[x[u], y[u]]]/scale[x[u], y[u]], 
     y'[u] == sign Im[flow[x[u], y[u]]]/scale[x[u], y[u]], x[0] == x0,
      y[0] == y0, 
     WhenEvent[
      x[u] < box[[1, 1]] || x[u] > box[[1, 2]] || y[u] < box[[2, 1]] ||
        y[u] > box[[2, 2]], "StopIntegration"]};
   (*Solve twice:one initial point per arm.*)
   solA = NDSolveValue[eqs[Re[z0a], Im[z0a]], {x, y}, {u, 0, umax}, 
     Method -> "StiffnessSwitching", MaxStepSize -> 0.05, 
     StartingStepSize -> 10^-4];
   solB = 
    NDSolveValue[eqs[Re[z0b], Im[z0b]], {x, y}, {u, 0, umax}, 
     Method -> "StiffnessSwitching", MaxStepSize -> 0.05, 
     StartingStepSize -> 10^-4];
   (*Return the two arms as plots.*){ParametricPlot[{solA[[1]][u], 
      solA[[2]][u]}, {u, 0, umax}, PlotStyle -> plotStyle, 
     PlotRange -> box, PlotRangeClipping -> True], 
    ParametricPlot[{solB[[1]][u], solB[[2]][u]}, {u, 0, umax}, 
     PlotStyle -> plotStyle, PlotRange -> box, 
     PlotRangeClipping -> True]}];

(*Convenience wrappers. Note that the Duals flow is reversed.*)
ThimbleArms[zS_, \[Delta]_, args___] := 
  ManifoldArms[zS, \[Delta], +1, 0, args];
DualArms[zS_, \[Delta]_, args___] := 
  ManifoldArms[zS, \[Delta], -1, Pi, args];

(*-------------------------Demo plots----------------------------*)

\[Delta] = deltaParam;
sads = Saddles[\[Delta]];
z0 = SelectSaddle[sads];

(*One saddle only - can be useful if you want to isolate a single \
thimble or dual.*)
(* This is just a basic template and can be developed to individual \
desire.*)
th = ThimbleArms[z0, \[Delta], 10^-5, 80, Directive[Thick, Blue]];
du = DualArms[z0, \[Delta], 10^-5, 80, 
   Directive[Dashed, Thick, Green]];

Show[ContourPlot[
   Re[W[x + I y, \[Delta]]], {x, box[[1, 1]], box[[1, 2]]}, {y, 
    box[[2, 1]], box[[2, 2]]}, Contours -> 20, ContourShading -> True,
    Frame -> False, PlotRange -> box], th, du, 
  Graphics[{Red, PointSize[Large], Point[{Re[z0], Im[z0]}]}], 
  AspectRatio -> 1, Axes -> True, PlotRange -> box, 
  PlotRangeClipping -> True, PlotRangePadding -> None];

(*All saddles in one plot with all thimbles.*)
thAll = Flatten[
   ThimbleArms[#, \[Delta], 10^-5, 80, Directive[Thick, Blue]] & /@ 
    sads];
duAll = Flatten[
   DualArms[#, \[Delta], 10^-5, 80, 
      Directive[Dashed, Thick, Green]] & /@ sads];

Show[ContourPlot[
  Re[W[x + I y, \[Delta]]], {x, box[[1, 1]], box[[1, 2]]}, {y, 
   box[[2, 1]], box[[2, 2]]}, Contours -> 20, ContourShading -> True, 
  Frame -> False, PlotRange -> box], thAll, duAll, 
 Graphics[{Red, PointSize[Large], 
   Point /@ ({Re[#], Im[#]} & /@ sads)}], AspectRatio -> 1, 
 Axes -> True, PlotRange -> box, PlotRangeClipping -> True, 
 PlotRangePadding -> None]