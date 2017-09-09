// Returns the 0/1 knapsack problem solution values given a weight and value variable and a weight budget.

version 12.0

cap prog drop knapsack
prog def knapsack , rclass

syntax anything , Weight(varname) Value(varname)

* Setup the matrix

  set matsize `anything'

  qui count
    local obs = `r(N)'
    local rows = `obs' + 1

  local theLabel : var label `value'

* Loop

mata: mata clear

  m {

    st_view(v=0,.,"`value'")
		v = 0 \ v
  	st_view(w=0,.,"`weight'")
		w = 0 \ w

    theSolutions = J(`rows',`anything',0)

    for(i=2;i<=`rows';i++) {
      for (j=1;j<=`anything';j++) {


        if(w[i] > j) {
          theSolutions[i,j] = theSolutions[i-1,j]
        }
        else {
		  opts = theSolutions[i-1, j], theSolutions[i-1, j-w[i]+1] + v[i]
          theSolutions[i, j] = max(opts)
        }

      }
    }

    sol = theSolutions[`rows',`anything']
    st_matrix("theSolution",sol)

  }

* Return the solution

  local sol = el(theSolution,1,1)

  di in red "Maximum Total `theLabel' = `sol'"

  return scalar max = `sol'

end

sysuse auto, clear

set trace off
set tracedepth 2
knapsack 500 , w(mpg) v(price)

di "`r(max)'"

* Have a lovely day!
