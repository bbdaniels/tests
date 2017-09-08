*! version 1.0


*****
* Adapted from https://github.com/coderigo/stata-git
*****

version 12.0
capture program drop wb_git_install
program define wb_git_install
syntax anything

    /*
    OS-dependent vars
    */
    local os         = "`c(os)'"
    local adoPlusDir = "`c(sysdir_personal)'"
    if("`os'" != "Windows"){
        local adoPlusDir = subinstr("`adoPlusDir'","~","/Users/`c(username)'",.)
    }
    local adoDir    = trim(subinstr("`adoPlusDir'","ado/personal/","",.))


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

wb_git_install stata_git

*
