on encode(value)
	set type to class of value
	if type = integer
		return value as text
	else if type = text
		return encodeString(value)
	else if type = list
		return encodeList(value)
	else if type = script
		return value's toJson()
	else
		error "Unknown type " & type
	end
end


on encodeList(value_list)
	set out_list to {}
	repeat with value in value_list
		copy encode(value) to end of out_list
	end
	set original_delimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ", "
	set rv to "[" & (out_list as text) & "]"
	set AppleScript's text item delimiters to original_delimiter
	return rv
end


on encodeString(value)
	set rv to ""
	repeat with ch in value
		if id of ch >= 32 and id of ch < 127
			set quoted_ch to ch
		else
			set quoted_ch to "\\u" & hex4(id of ch)
		end
		set rv to rv & quoted_ch
	end
	return "\"" & rv & "\""
end


on hex4(n)
	set digit_list to "0123456789abcdef"
	set rv to ""
	repeat until length of rv = 4
		set digit to (n mod 16)
		set n to (n - digit) / 16 as integer
		set rv to (character (1+digit) of digit_list) & rv
	end
	return rv
end


on createDict()
	script Dict
		on toJson()
			return "{}"
		end
	end

	return Dict
end
