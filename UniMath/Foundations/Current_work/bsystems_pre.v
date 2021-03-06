Require Export Foundations.Current_work.pretowers.

Unset Automatic Introduction.



(* To pretowers.v *)

Definition pretfibplus { n : nat } { T : pretower } ( G : T n ) : pretower := ( pretowerpb ( pretowernshift n T ) ( fromunit G ) ) .

Definition frompretfibplus { n : nat } { T : pretower } ( G : T n ) : pretowerfun ( pretfibplus G ) ( pretowernshift n T ) := 
pretowerpbpr _ _ .  


(* The type of carriers of B-systems - towers together with a one step ramification at each floor except for the ground floor. In 
existing examples the ground floor of a B-system is always the unit type which corresponds to the fact that there is only one empty
 context. *)


Definition bsyscar := total2 ( fun T : pretower => forall ( n : nat ) ( GT : T ( S n ) ) , UU ) . 
Definition bsyscarpair ( T : pretower ) ( btilde : forall ( n : nat ) ( GT : T ( S n )  ) , UU ) : bsyscar := tpair _ T btilde . 

Definition bsyscartopretower ( B : bsyscar ) := pr1 B .
Coercion bsyscartopretower : bsyscar >-> pretower.

Definition obj { n : nat } { B : bsyscar } ( GT : B ( S n ) ) : UU := ( pr2 B ) n GT . 

Definition ft { n : nat } { B : bsyscar } ( GT : B ( S n ) ) : B n := pretowerpn B n GT . 




(** Functions between B-system carriers *)


Definition bsyscarfunfam ( B B' : bsyscar ) : pretowerfun B B' -> UU := 
fun f : pretowerfun B B' => forall ( n : nat ) ( GT : B ( S n ) ) , obj GT -> obj ( f ( S n ) GT ) .

Definition bsyscarfun ( B B' : bsyscar ) : UU := total2 ( bsyscarfunfam B B' ) .
   
Definition bsyscarfuntopretowerfun ( B B' : bsyscar ) : bsyscarfun B B' -> pretowerfun B B' := pr1 .
Coercion bsyscarfuntopretowerfun : bsyscarfun >-> pretowerfun .

Definition objfun { n : nat } { B B' : bsyscar } ( f : bsyscarfun B B' ) { GT : B (S n ) } ( t : obj GT ) :
 obj ( f ( S n ) GT ) := ( pr2 f ) n GT t .

Definition bsyscaridfun ( B : bsyscar ) : bsyscarfun B B := 
tpair ( bsyscarfunfam B B ) ( pretoweridfun B ) ( fun n => fun GT => idfun ( obj GT ) ) . 

Definition bsyscarfuncomp { B B' B'' : bsyscar } ( f : bsyscarfun B B' ) ( g : bsyscarfun B' B'' ) : bsyscarfun B B'' :=
tpair ( bsyscarfunfam B B'' ) ( pretowerfuncomp f g ) ( fun n => fun GT : B ( S n ) => fun t : obj GT => objfun g ( objfun f t ) ) . 



(** B-system carrier over a context *)

Definition bsyscarover { n : nat } { B : bsyscar } ( G : B n ) : bsyscar :=
 bsyscarpair ( pretfibplus G ) 
( fun m : nat => fun DT : ( pretfibplus G ) ( S m )  => 
@obj ( ( m + n ) ) B ( frompretfibplus G _ DT ) )  . 

Definition tocarover { n : nat } { B : bsyscar } ( GT : B ( S n ) ) : bsyscarover ( ft GT ) 1 := tohfpfiber _ GT . 

Definition fromcarover { m n : nat } { B : bsyscar } { G : B n } ( GD : bsyscarover G m ) : B ( m + n ) := 
frompretfibplus G _ GD . 




(** Double B-system carriers *)

Definition doublebsyscar_from { m n : nat } { B : bsyscar } { G : B n } ( GD : bsyscarover G m ) : 
bsyscarfun ( bsyscarover GD ) ( bsyscarover ( fromcarover GD ) ) .  
Proof. intros . refine ( tpair _ _ _ ) . ???











(** Structures on bsystemcarriers which together form the data of a B-system. *)

(* Operations 

T : ( Gamma, x:T |- ) => ( Gamma , Delta |- ) => ( Gamma, x:T, Delta |- ) 

and

Ttilde : ( Gamma, x:T |- ) => ( Gamma , Delta |- s : S ) => ( Gamma, x:T, Delta |- s : S ) 

combined into a function of B-system carriers from the carrier over (Gamma) to the carrier over (Gamma,T) .*)

Definition Tops ( B : bsyscar ) := 
forall ( n : nat ) ( GT : B ( S n ) ) , bsyscarfun ( bsyscarover ( ft GT ) ) ( bsyscarover GT ) . 

Definition Topsover { B : bsyscar } { n : nat } ( G : B n ) ( TT : Tops B ) : Tops ( bsyscarover G ) .
Proof . intros. intros m GDT . 

set ( GDT' := fromcarover GDT : B ( S ( m + n ) ) ) . 

assert ( f1 : bsyscarfun ( bsyscarover ( ft GDT ) ) ( bsyscarover ( ft GDT' ) ) ) . 


(* Operations

S : ( Gamma |- s : S ) => ( Gamma , x:S, Delta |- ) => ( Gamma, Delta[s/x] |- ) 

and

Stilde : ( Gamma |- s : S ) => ( Gamma , x:S, Delta |- r : R ) => ( Gamma, Delta[s/x] |- r[s/x]:R[s/x]) 

combined into a function of B-system carriers from the carrier over (Gamma, S) to the carrier over (Gamma). *)


Definition Sops ( B : bsyscar ) := 
forall ( n : nat ) ( GS : B ( S n ) ) ( s : obj GS ) , bsyscarfun ( bsyscarover GS ) ( bsyscarover ( ft GS ) ) . 



(* Operations

Dops : ( Gamma, x:T |- ) => ( Gamma, x : T |- x : T ) *)

Definition Dops ( B : bsyscar ) ( T : Tops B ) := 
forall ( n : nat ) ( GT : B ( S n ) ) , obj ( T n GT 1 ( tocarover GT ) ) . 



(** The data for a B-system *)

Definition bsysdata : UU := total2 ( fun B : bsyscar => total2 ( fun SS : Sops B => total2 ( fun T : Tops B => Dops B T )  ) ) . 

Definition bsysdata_to_bsyscar : bsysdata -> bsyscar := pr1 . 
Coercion bsysdata_to_bsyscar : bsysdata >-> bsyscar .

Definition SS { B : bsysdata } { m n : nat } { GS : B ( S n ) } ( s : obj GS ) ( GD : bsyscarover GS m ) :
 bsyscarover ( ft GS ) m := ( pr1 ( pr2 B ) ) n GS s m GD .

Definition SSt { B : bsysdata } { m n : nat } { GS : B ( S n ) } ( s : obj GS ) { GSDR : bsyscarover GS ( S m ) } ( r : obj GSDR ) : obj ( SS s GSDR ) := objfun ( ( pr1 ( pr2 B ) ) n GS s ) r . 
 
Definition TT { B : bsysdata } { m n : nat } ( GT : B ( S n ) ) ( GD : bsyscarover ( ft GT ) m ) :
 bsyscarover GT m := ( pr1 ( pr2 ( pr2 B ) ) ) n GT m GD . 

Definition TTt { B : bsysdata } { m n : nat } ( GT : B ( S n ) ) { GDS : bsyscarover ( ft GT ) ( S m ) } ( s : obj GDS ) : obj ( TT GT GDS ) := objfun ( ( pr1 ( pr2 ( pr2 B ) ) ) n GT ) s . 

Definition DD { B : bsysdata } { n : nat } ( GT : B ( S n ) ) : obj ( TT GT ( tocarover GT ) ) := ( pr2 ( pr2 ( pr2 B ) ) ) n GT .



(** Axioms *)

Definition TTTT { B : bsysdata } ( GA : B ( S n ) ) ( GDB : bsysdataover ( ft G ) ) ???






(** Iterated operations *)

(** Operation 

ft j : ( Gamma, Gamma' ) => ( Gamma )  *)

Definition ftj ( j : nat ) { n : nat } { T : pretower } ( GG' : T ( j + n ) ) : T n .
Proof. intros j n T . induction j as [ | j IHj ] . intro GG' .  exact GG' . intro GG' . simpl in GG' . exact ( IHj (  pretowerpn T ( j + n ) GG' ) ) .  Defined. 


(* Operations 

T : ( Gamma, Gamma' |- ) => ( Gamma , Delta |- ) => ( Gamma, Gamma' , Delta |- ) 

and

Ttilde : ( Gamma, Gamma' |- ) => ( Gamma , Delta |- s : S ) => ( Gamma, Gamma' , Delta |- s : S ) 

combined into a function of B-system carriers from the carrier over (Gamma) to the carrier over (Gamma,Gamma') .*)



Definition TTj { j n : nat } { B : bsysdata } ( GG' : B ( j + n ) ) : bsyscarfun ( bsyscarover ( ftj j GG' ) ) ( bsyscarover GG' ) . 
Proof. intro j . induction j as [| j IHj]. intros . exact bsyscaridfun . 






(* To be removed:

Definition pretfib_Tn_jn ( pT : prepretower ) ( t : pT 0 ) ( n : nat ) : total2 ( fun pretfibn : UU => pretfibn -> pT ( S n ) ) .
Proof . intros . induction n .  

split with (hfiber ( prepretowerpn pT O ) t ) .  exact pr1 . 

split with ( hfp ( pr2 IHn ) ( prepretowerpn pT ( S n ) ) ) . exact ( hfppru ( pr2 IHn ) ( prepretowerpn pT ( S n ) ) ) . Defined. 

Definition pretfib_Tn ( pT : prepretower ) ( t : pT 0 ) ( n : nat ) : UU  := pr1 ( pretfib_Tn_jn pT t n ) . 

Definition pretfib_jn ( pT : prepretower ) ( t : pT 0 ) ( n : nat ) : pretfib_Tn pT t n -> pT ( S n ) := pr2 (  pretfib_Tn_jn pT t n ) . 

Definition pretfib_pn ( pT : prepretower ) ( t : pT 0 ) ( n : nat ) : pretfib_Tn pT t ( S n ) -> pretfib_Tn pT t n .
Proof. intros pT t n .  exact ( hfpprl ( pr2 ( pretfib_Tn_jn pT t n ) ) ( prepretowerpn pT ( S n ) ) ) . Defined. 

Definition pretfib { pT : prepretower } ( t : pT 0 ) : prepretower := prepretowerpair ( pretfib_Tn pT t ) ( pretfib_pn pT t ) . 

Lemma pr0pretfib ( pT : prepretower ) ( t : pT 0 ) : paths ( pretfib _ t  0 ) ( hfiber ( prepretowerpn pT O ) t ) . 
Proof. intros. apply idpath .  Defined. 

Definition prepretowerfuntfib_a { pT pT' : prepretower } ( f : prepretowerfun pT pT' ) ( t : pT 0 ) ( n : nat ) : total2 ( fun funtfibn : ( pretfib _ t n ) -> ( pretfib _ ( f 0 t ) n ) => commsqstr ( f ( S n ) ) ( pretfibj ( f 0 t ) n ) ( pretfibj t n ) funtfibn ) .
Proof. intros pT pT' f t n . induction n as [ | n IHn ] .  

split with ( hfibersgtof' ( f 0 ) ( prepretowerpn pT' 0 ) ( prepretowerpn pT 0 ) ( f 1 ) ( prehn f 0 ) t ) . intro . About commsqstr .  apply idpath . ???


split with ( hfpcube ( f ( S n ) ) ( prepretowerpn pT ( S n ) ) ( prepretowerpn pT' ( S n ) ) ( f ( S ( S n ) ) )  ( pretfibj pT t n ) ( pretfibj pT' ( f 0 t ) n ) ( pr1 IHn ) ( prehn f ( S n ) ) ( pr2 IHn ) ) .  intro. apply idpath .  Defined. 

*)

(* To be erased 

Definition freefunctions : UU := total2 ( fun XY : dirprod UU UU => ( pr1 XY -> pr2 XY ) ) . 

Definition freefunctionstriple { X Y : UU } ( f : X -> Y ) : freefunctions := tpair ( fun XY : dirprod UU UU => ( pr1 XY -> pr2 XY ) ) ( dirprodpair X Y ) f . 

Definition ptsteps ( pT : prepretower ) ( n : nat ) : freefunctions := freefunctionstriple ( prepretowerpn pT n ) . 

(* *)

*)


(* End of file bsystems_pre.v *)

