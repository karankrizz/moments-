class Crush < ApplicationRecord
  #search
 	scope :search, lambda { |query|
 	   return nil  if query.blank?
 	 # Searches the students table on the 'first_name' and 'last_name' columns.
 	 # Matches using LIKE, automatically appends '%' to each term.
 	 # LIKE is case INsensitive with MySQL, however it is case
 	 # sensitive with PostGreSQL. To make it work in both worlds,
 	 # we downcase everything.
 	 # condition query, parse into individual keywords
 	 terms = query.downcase.split(/\s+/)

 	 # replace "*" with "%" for wildcard searches,
 	 # append '%', remove duplicate '%'s
 	 terms = terms.map { |e|
 	   (e.gsub('*', '%').prepend('%') + '%').gsub(/%+/, '%')
 	 }
 	 # configure number of OR conditions for provision
 	 # of interpolation arguments. Adjust this if you
 	 # change the number of OR conditions.
 	 num_or_conds = 1
 	 where(
 	   terms.map { |term|
 	     "( CAST(crush_number AS TEXT) LIKE ?)"
 	   }.join(' AND '),
 	   *terms.map { |e| [e] * num_or_conds }.flatten
 	 )
 	}
end
