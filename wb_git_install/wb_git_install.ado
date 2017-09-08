*! version 1.0

version 12.0
capture program drop wb_git_install
program define wb_git_install
syntax anything // Needs the name of the command only.

  local adoPlusDir = "`c(sysdir_personal)'"

  local os = "`c(os)'"
  if("`os'" != "Windows"){
      local adoPlusDir = subinstr("`adoPlusDir'","~","/Users/`c(username)'",.)
  }

  local adoDir      = trim(subinstr("`adoPlusDir'","ado/personal/","",.))
	local firstLetter = lower(substr("`anything'",1,1))

    qui cap mkdir "`adoPlusDir'/`firstLetter'/"
    qui cd "`adoPlusDir'/`firstLetter'/"

	copy ///
		"https://raw.githubusercontent.com/bbdaniels/tests/master/`anything'/`anything'.ado" ///
		"`anything'.ado" , replace

	copy ///
		"https://raw.githubusercontent.com/bbdaniels/tests/master/`anything'/`anything'.sthlp" ///
		"`anything'.sthlp" , replace

	di in red "Installed `anything' to `adoPlusDir'/`firstLetter'"

end

* Demo usage: wb_git_install stata_git

*
