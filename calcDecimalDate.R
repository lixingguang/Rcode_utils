# function to calculate decimal date
# S. J. Lycett
# 27 Oct 2010
# 15 Dec 2010 - defaultDay & defaultMonth set to 1, if defaultDay & DefaultMonth = -1 then random day and month are chosen
# from matrixTranslate.R version 3 June 2010

# 19 May 2011
# from matrixTranslate.R version 7 April 2011

# 4 August 2011 - corrected calcDecimalDate_from_yymmdd (defaultMonth was wrong)
# 15 Mar 2013 - calcDecimalDate_from_yymmdd will now run if e.g. 1934//

# Rcode_utils is free software: you can redistribute it and/or modify it under the terms of the 
# GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
# Rcode_utils is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
# See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with Rcode_utils.  
# If not, see <http://www.gnu.org/licenses/>.

calcDecimalDate	<- function(day, month, year, defaultMonth=6, defaultDay=15) {
	cd	<- c(0,  31,  59,  90, 120, 151, 181, 212, 243, 273, 304, 334)

	if (month==0) {
		if (defaultMonth >= 1) {
			month <- defaultMonth
		} else {
			month	<- ceiling(runif(1)*12)
		}
	}

	if (day==0) {
		if (defaultDay >= 1) {
			day	<- defaultDay
		} else {
			day	<- ceiling(runif(1)*30)
		}
	}

	dd	<- cd[month] + day - 1
	
	decDate <- year + (dd/365)

	return ( decDate )
}

invertDecimalDate <- function( decDate ) {
	cd	<- c(0,  31,  59,  90, 120, 151, 181, 212, 243, 273, 304, 334, 365)
	fractD<- cd/365

	year		<- floor(decDate)
	fractYear 	<- decDate-year
	month		<- which(fractD >= fractYear)[1]-1

	if (month > 0) {
		fractMonth  <- fractYear-fractD[month]
		day		<- round((fractMonth*365)+1)
	} else {
	      month <- 1
		day   <- 1
	}

	return( c(day,month,year) )
}

calcDecimalDate_fromTxt	<- function( dateTxt, sep="/") {
	els 	<- strsplit(dateTxt, sep)[[1]]
	year 	<- as.integer(els[1])

	if (length(els)==1) {
		month <- 7
		day	<- 2
	}
	
	if (length(els)==2) {
		if (nchar(els[2]) > 0) {
			month <- as.integer(els[2])
			day	<- 15
		} else {
			month <- 7
			day   <- 2
		}
	}

	if (length(els)==3) {
		month <- as.integer(els[2])
		if (nchar(els[3]) > 0) {
			day 	<- as.integer(els[3])
		} else {
			day <- 15
		}
	}

	decDate <- calcDecimalDate(day, month, year)
	return ( decDate )
}


calcDecimalDate_from_yymmdd	<- function( dateTxt, sep="/", ycutoff=12, defaultMonth=6, defaultDay=15 ) {
	els	<- strsplit(dateTxt, sep)[[1]]
	yy	<- as.integer(els[1])
	mm	<- as.integer(els[2])
	dd	<- as.integer(els[3])

	if (!is.finite(yy)) {
		return( -1 )
	} else {
		if (yy <= ycutoff) {
			yy <- yy+2000
		}
		if ((yy > ycutoff) & (yy < 99)) {
			yy <- yy+1900
		}

		if (!is.finite(mm)) {
			mm <- 0
		}
		if (!is.finite(dd)) {
			dd <- 0
		}
		return ( calcDecimalDate( dd, mm, yy, defaultMonth=defaultMonth, defaultDay=defaultDay ) )
	}
	
}