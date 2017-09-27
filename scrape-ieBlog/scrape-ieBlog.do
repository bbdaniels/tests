* Scrape ieBlog into CSV

// Load the site

  clear

  tempfile theLinks
    save `theLinks' , replace emptyok

  import delimited ///
    using "https://blogs.worldbank.org/impactevaluations/blog"

  keep v1

// Find max pageno

  keep if regexm(v1,`"last page"')
  replace v1 = substr(v1,strpos(v1,"last page"),.)
  replace v1 = substr(v1,strpos(v1,"page=")+5,.)
  replace v1 = substr(v1,1,strpos(v1,`"""')-1)

  local maxPage = v1[1]
  di `"`maxPage'"'

// Loop over pages

  qui forvalues pageno = 1/`maxPage' { //

    clear
    import delimited ///
      using "https://blogs.worldbank.org/impactevaluations/frontpage?page=`pageno'"
      keep v1

      keep if regexm(v1,"h2 class")
      keep if regexm(v1,"node-title")

      local instance = v1[1]
      di `"`instance'"'

      split v1 , parse("title=")
      drop v1

      replace v11 = subinstr(v11,`"<h2 class="node-title node-title"><a href=""',"http://blogs.worldbank.org",.)
      replace v12 = substr(v12,1,strpos(v12,">")-1)

      replace v11 = subinstr(v11,`"""',"",.)
      replace v12 = subinstr(v12,`"""',"",.)

      gen theLink = "[" + v12 + "]" + "(" + v11 + ")"

      drop v*

      tempfile theseLinks
        save `theseLinks' , replace

      use `theLinks' , clear
        append using `theseLinks'
        save `theLinks' , replace

    }

    replace theLink = subinstr(theLink,"â","'",.)
    replace theLink = subinstr(theLink,"â","-",.)
    replace theLink = subinstr(theLink,"â¦","!",.)
    replace theLink = itrim(trim(theLink))

    export delimited using ///
      "/Users/bbdaniels/GitHub/tests/scrape-ieBlog/ieBlog.csv" , replace

    import delimited using ///
      "/Users/bbdaniels/GitHub/tests/scrape-ieBlog/ieBlog.csv" , clear

	 replace v1 = subinstr(v1,"Ã¢ÂÂ","-",.)

	 drop in 1

	 export delimited using ///
      "/Users/bbdaniels/GitHub/tests/scrape-ieBlog/ieBlog.csv" , replace

* Have a lovely day!
