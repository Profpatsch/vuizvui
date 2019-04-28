  λ(Pkg : Type)
→ let PkgO = λ(o : Type → Type) → { name : o Text, configurePhase : o Text }

  let PkgOpt = PkgO Optional

  in    λ(pkgs : Text → Pkg)
	  → λ(override : Pkg → PkgOpt → Pkg)
	  → override
		(pkgs "hello")
		{ name = Some "see-ya", configurePhase = Some "echo NOPE" }