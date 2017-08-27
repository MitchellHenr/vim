execute ":normal A# filename:      \e\"%p"
execute ":normal A\rauthor:        Henry Mitchell"
execute ":normal A\rcreation date: \e:put =strftime('%d %b %Y')\ri\b"
execute ":normal o\rdescription:   \r"
