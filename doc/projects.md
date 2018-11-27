# Research at TCS Research Group

Christiano Braga  
Universidade Federal Fluminense  
[http://www.ic.uff.br/~cbraga/tcs](http://www.ic.uff.br/~cbraga/tcs)  

Nov. 28, 2018

## Research insterests

* Formal semantics in compiler construction and program analysis.

* Automata-based verification techniques for component-based system.

## Outline of current research projects

### &pi; Framework overview  

* [http://github.com/ChristianoBraga/PiFramework](http://github.com/ChristianoBraga/PiFramework)  

* &pi; is a semantic framework to teach formal compiler construction.  

* It joins Peter Mosses' _funcons_, from [Component-Based Semantics](https://plancomps.github.io/CBS-beta), 
with Gordon Plotkin's [Interpreting Automata](http://homepages.inf.ed.ac.uk/gdp/publications/sos_jlap.pdf).

* Implementations in Maude, Python and Racket.

* Research in the context of Language-oriented Programming and Program Analysis.

### B Maude overview  

* [https://github.com/ChristianoBraga/BMaude](https://github.com/ChristianoBraga/BMaude)

* Joint work with Narciso Martí Oliet.

* Is a prototype executable environment for specifications in the Abstract Machine Notation, 
the description language used in Abrial's [B Method](https://www.methode-b.com/en/).

* The project started with the intention to build a collaboration with Brazilian colleagues 
David Deharbe and Anamaria Moreira, specialists in the B Method.  

* There exists a possibility of collaboration with 
[ClearSy Systems Engineering](https://www.clearsy.com/en/). (They develop the [Attelier B](https://www.atelierb.eu/en/) tool.)

### Component-based Cyber-Physical Systems overview  

* The semantics of a component in a Cyber-Physical Systems (CPS) is specified by a hybrid automaton.  

* The model of a Component-based CPS (CB-CPS) is the result of the synchronous product of the hybrid automata of its components.  

* A hybrid automaton is represented as a rewrite theory controled by a strategy.  
  * Both discrete and timed transitions are rules. The strategy makes sure that the discrete transitions are applied as much as 
  possible before the timed-transitions are applied. (Should yield a behavior equivalent to real-time rewrite theories.)

* Master thesis of Andre Metelo at UFF, in a joint work with Diego Brandão.

## &pi; Framework

* It has two components: &pi; Lib and &pi; Automaton.  

* &pi; Lib is a set of basic programming language contructs, in the spirit of the _funcons_ in Component Based Semantics.  
  * A smaller set than _funcons_ from CBS is chosen, though. Only enough to talk about _facets_ 
(in the Action Semantics sense) expressions, commands, declarations and abstractions.

  ```haskell  
  Cmd ::= `loop`(Exp, Cmd)
  ```

  * A `call/cc` primitive will be incorporated in the next release. (This will endow the framework with exceptions and co-routines.)

* &pi; Automaton is a simple stack-based machine that gives operational meaning to &pi; Lib constructs.
  * Currently, only the dynamic semantics of programming languages is supported.
  * Essentially, the state of a &pi; automaton is a tuple, denoting syntax (control stack) and semantic components 
  (such as value stack, memory store, environmnent), and transitions are induced by _unconditional_ rules relating states.
  * It extends the concept of Interpreting Automata by Gordon Plotkin, following Modular SOS, Modular Rewriting Semantics and K.  
  * The mathematical notation follows standard notation from Automata Theory, as Compiler Construction courses usually follows Formal Languages and Automata Theory courses at undergraduate level.  
    > _δ : L(G)<sup>* </sup> × L(G)<sup>* </sup>  × Store → Q_  
    > _δ(Loop(X,M) :: C, V, E, S) = δ(X :: #LOOP :: C, Loop(X,M)::V, E, S)_  
    > _δ(#LOOP :: C, Boo(true) :: Loop(X,M) :: V, E, S) = δ(M :: Loop(X,M) :: C, V, E, S)_  
    > _δ(#LOOP :: C, Boo(false) :: Loop(X,M) :: V, E, S) = δ(C, V, E, S)_  

* To give semantics to a programming language one needs to define &pi; denotations for 
  the given programming language constructs, that is, functions relating the given 
  programming language construct and &pi; Lib constructs.  
  
  * In the example below, _WHILE_, of syntactical 
  class GSLSubstitution, is being related with _loop_, of syntactical class Cmd.  
    <a name="pd-while"></a>
    > _&#10214; _ &#10215; <sub>&pi;</sub> : GSLSubstitution → Cmd_  
    > _&#10214; WHILE P:GSLPredicate DO S:GSLSubstitution) &#10215; <sub>&pi;</sub> =
    > loop(&#10214; P:GSLPredicate &#10215; <sub>&pi;</sub> , &#10214; S:GSLSubstitution &#10215; <sub>&pi;</sub>)_

### &pi; Framework in Maude  

* &pi; Lib constructs are represented by the signature of a system module.

* &pi; Lib constructs with terminating semantics are equationally specified and (possibly) non-terminating constructs are specified by rules.  

  ```haskell
  var ... : Set{SemComp} .  
  var E : Env .  
  var S : Store .  
  var C : ControlStack .  
  var V : ValueStack .  

  eq [loop] :
  < cnt : loop(E:Exp, K:Cmd) C, val : V, ... > =
  < cnt : E:Exp LOOP C,
    val : val(loop(E:Exp, K:Cmd)) V, ... > [variant] .

  rl [loop] :
  < cnt : LOOP C,
    val : val(true) val(loop(E:Exp, K:Cmd)) V, ... > =>
  < cnt : K:Cmd loop(E:Exp, K:Cmd) C,
    val : V, ... > [narrowing] .

  eq [loop] :
  < cnt : LOOP C,
    val : val(false) val(loop(E:Exp, K:Cmd)) V, ... > =
  < cnt : C, val : V, ... > [variant] .
  ```  

* &pi; denotations are equtionally specified.

  ```haskell
  op compile : GSLSubstitution -> Cmd .
  eq compile(WHILE P:GSLPredicate DO S:GSLSubstitution) =  
     loop(compile(P:GSLPredicate), compile(S:GSLSubstitution)) .
  ```  

* The execution environment allows for simulation by term rewriting, symbolic execution by narrowing
and LTL model checking. (See examples in B Maude project.)

### &pi; Framework in Python

* Both &pi; Lib and Automata are represented as classes, organized by syntactical classes and facets, respectively.

* A class constructor has a similar meaning of an algebraic constructor operation. 
In the example below `__init__` is the (object) constructor and `cond` and `body` are projection 
functions.  

```python
class Loop(Cmd):
    def __init__(self, be, c):
        if isinstance(be, BoolExp):
            if isinstance(c, Cmd):
                Cmd.__init__(self, be, c)
            else:
                raise IllFormed(self, c)
        else:
            raise IllFormed(self, be)

    def cond(self):
        return self.operand(0)

    def body(self):
        return self.operand(1)
```  

* The &pi; automaton for the commands facet extends the one for expressions.  
  * The automaton for expressions extends Plotkin's Interpreting Automaton, 
  that has a control stack and value stack, with an environment and store, in order to give semantics
  for identifiers.

```python
class CmdPiAut(ExpPiAut):
    # ...
    def __evalLoop(self, c):
        be = c.cond()
        bl = c.body()
        self.pushVal(Loop(be, bl))
        self.pushVal(bl)
        self.pushCnt(CmdKW.LOOP)
        self.pushCnt(be)

    def __evalLoopKW(self):
        t = self.popVal()
        if t:
            c = self.popVal()
            lo = self.popVal()
            self.pushCnt(lo)
            self.pushCnt(c)
        else:
            self.popVal()
            self.popVal()

```

* &pi; denotations (for the Im&pi; language) are implemented as semantic functions of the parser generated by [竜 Tatsu](https://github.com/neogeny/TatSu). 

```python
    # Imp.ebnf
    cmd = loop | ... ;

    # Impiler.py
    class Impiler(object):
        # ...
        def loop(self, ast):
            if isinstance(ast.c, pi.Cmd):
                return pi.Loop(ast.e, ast.c)
            else:
                cmd = ast.c[0]
                for i in range(1, len(ast.c)):
                    cmd = pi.CSeq(cmd, ast.c[i])
                return pi.Loop(ast.e, cmd)
```

* Allows for [LLVM code generation](http://github.com/ChristianoBraga/PiFramework/blob/master/python/Pi_Framework___LLVM.pdf) using [LLVM Lite](https://github.com/numba/llvmlite) and Just in Time (JIT) compilation, 
developed in collaboration with [Fernando Mendes](https://github.com/fjmendes1994). The following example implements the factorial function (of 10) ...

```ocaml
Imπ source code:
# The classic iterative factorial example
let var z = 1
in
    let var y = 10
    in
        while not (y == 0)
        do
            z := z * y
            y := y - 1

State #232 of the π automaton:
locs : [0]
env : {'z': 0}
sto : {0: 3628800}
val : [[], {}]
cnt : ['#BLKCMD']

Number of evaluation steps: 234
Evaluation time: 0:00:00.004149
```  

* ... that is transformed into the following LLVM code by the Im&pi; compiler.  

```llvm
; ModuleID = "main_module"
target triple = "x86_64-apple-darwin18.0.0"
target datalayout = ""

define i64 @"main_function"()
{
entry:
  %"ptr" = alloca i64
  store i64 1, i64* %"ptr"
  %"ptr.1" = alloca i64
  store i64 10, i64* %"ptr.1"
  br label %"loop"
loop:
  %"val" = load i64, i64* %"ptr.1"
  %"temp_eq" = icmp eq i64 %"val", 0
  %"temp_not" = xor i1 %"temp_eq", -1
  %"val.1" = load i64, i64* %"ptr"
  %"val.2" = load i64, i64* %"ptr.1"
  %"tmp_mul" = mul i64 %"val.1", %"val.2"
  store i64 %"tmp_mul", i64* %"ptr"
  %"val.3" = load i64, i64* %"ptr.1"
  %"tmp_sub" = sub i64 %"val.3", 1
  store i64 %"tmp_sub", i64* %"ptr.1"
  br i1 %"temp_not", label %"loop", label %"after_loop"
after_loop:
  ret i64 0
}
```

## B Maude

* B Maude is an executable enviroment for the Abstract Machine Notation (AMN), the description language of the B method.

* It essentially defines a theory transformation from the one decribing AMN syntax to the &pi; Lib theory, that is, 
it implements the &pi; denotations of AMN.

* The &pi; denotation for the [_WHILE_ construct](#pd-while) above is an example.  

```haskell
BMaude: Machine FACT loaded.
rewrites: 89 in 0ms cpu (1ms real) (99775 rewrites/second)
MACHINE FACT
 VARIABLES y
 VALUES y = 1
 OPERATIONS
  fact(x)=
   WHILE ~(0 == x) DO y := y * x ; x := x - 1 ; print(y)
END
rewrites: 26127 in 318ms cpu (322ms real) (82007 rewrites/second)
BMaude: Execution result
402387260077093773543702433923003985719374864210714632543799910429938...
```

* Another simple example is AMN non-deterministic bounded choice, which in Maude is coded as follows:

```haskell
eq compile(S1:GSLSubstitution [] S2:GSLSubstitution) =
   choice(compile(S1:GSLSubstitution), compile(S2:GSLSubstitution)) .
```

* Concurrent systems, such as the solutions for the mutual exclusion problem, can than be specified ...  

```haskell
BMaude: Machine MUTEX loaded.
Maude> (view)
rewrites: 483 in 2ms cpu (2ms real) (182746 rewrites/second)
MACHINE MUTEX
 VARIABLES p1, p2
 CONSTANTS idle, wait, crit
 VALUES crit = 2 ; idle = 0 ; p1 = 0 ; p2 = 0 ; wait = 1
 OPERATIONS
  mutex =
   WHILE true DO
    IF p2 == idle /\ p1 == idle
    THEN p2 := wait [] p1 := wait
    ELSE
     IF wait == p2 /\ p1 == idle
     THEN p2 := crit [] p1 := wait
     ELSE
      IF p1 == idle /\ p2 == crit
      THEN p2 := idle [] p1 := wait
      ELSE
       IF wait == p1 /\ p2 == idle
       THEN p2 := wait [] p1 := crit
       ELSE
        IF wait == p2 /\ wait == p1
        THEN p2 := crit [] p1 := crit
        ELSE
         IF wait == p1 /\ p2 == crit
         THEN p2 := idle
         ELSE
          IF p2 == idle /\ p1 == crit
          THEN p2 := wait [] p1 := idle
          ELSE
           IF wait == p2 /\ p1 == crit
           THEN p1 := idle
           ELSE skip
           END
          END
         END
        END
       END
      END
     END
    END
END
```

* ... and model checked for linear temporal logic properties, such as liveness.

```haskell
Maude> (mc mutex() |= [] (p1(1) -> <> p1(2)))
rewrites: 1009 in 40ms cpu (41ms real) (24825 rewrites/second)
BMaude: Model check counter example
Path from the initial state:
WHILE(true)...[p1 = 0 p2 = 0]-> WHILE(true)...[p1 = 0 p2 = 0]-> p2
    := wait OR p1 := wait[p1 = 0 p2 = 0]
Loop:
WHILE(true)...[p1 = 1 p2 = 0]-> p2 := wait OR p1 := crit[p1 = 1 p2 =
    0]-> WHILE(true)...[p1 = 1 p2 = 1]-> p2 := crit OR p1 := crit[p1
    = 1 p2 = 1]-> WHILE(true)...[p1 = 1 p2 = 2]
```

## Component-based Cyber-physical Systems

* Cyber-physical Systems (CPS) are distributed system where its components are either sensors or actuators.

* Such components can be modeled as _hybrid_ automata: finite state transition systems that allows for 
both discrete-time and continuous-time transitions.

* The model of a _Component-based_ CPS (CB-CPS) is the _synchronous product_ of hybrid automata of its constituent components.

* In general, continuous-time transitions are modeled by a system of _differential_ equations. 
A LHA is a Hybrid Automaton where its differential equations are:  

  * ordinary and Lipschitz continuous;  
  * any test or attribution within the model of the LHA are affine, that is, 
  a linear equation of the form a<sub>1</sub>x<sub>1</sub>+a<sub>2</sub>x<sub>1</sub>+...
  +a<sub>n</sub>x<sub>n</sub> ∼ 0 where ∼ is a comparison operation that can be one of <, ≤, =, ≥ or > 
  and an attribution is in the form 
  x<sub>i</sub> = a<sub>0</sub>+a<sub>1</sub>x<sub>1</sub>+a<sub>2</sub>x<sub>2</sub>+...+a<sub>n</sub>x<sub>n</sub> 
  and a<sub>0</sub>, a<sub>1</sub>, ... , a<sub>n</sub> are integer or real constants.

* We give a rewriting semantics for LHA that have an additional constraint: they are assumed _eager_ in the sense that 
if a discrete transition is _enabled_ it will take place. The state invariants must be properly specified to guarantee eagerness.

* The behavioral semantics of a given component is denoted by a rewrite theory. Both discrete and continuous time transitions
are modeled by rules. The rewrites that are deductible in the given theory are controled by a strategy that
applies the discrete-time transitions as much as possible before applying the continuous-time rule.

* The rewrite theory that models a given CB-CPS is the synchronous product of the rewrite systems of its
constituent components.

* We have developed some small case studies. There are still semantic issues to be worked out.