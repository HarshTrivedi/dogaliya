module PreprocessingHelper

	@@full_sanitizer = Rails::Html::FullSanitizer.new
	normalizing_workbook = RubyXL::Parser.parse(File.join 'public', "normalizing_rules.xlsx")
	@@normalizing_table = normalizing_workbook[0].get_table(["from_normalize" , "to_normalize"])[:table]

	def sanitize_hash(hash)
		return hash.update(hash) do |key,value|
			if value.class == ActiveSupport::HashWithIndifferentAccess
				sanitize_hash(value)
			else
				sanitize(value)
			end
		end
	end

	def sanitize(text)
		@@full_sanitizer.sanitize(text.strip)
	end

	def hinglish_normalizer(word , applied_rules_hash = {})
		return word if word.nil?

		word.downcase!
		hash = {}
		@@normalizing_table.each{|x| hash[x["from_normalize"]] = x["to_normalize"]  }
		from_to_hash = {} ; froms = [] ; 
		hash.keys.each{|from| froms += from.split("||");  from.split("||").each{|e| from_to_hash[e.strip] = hash[from.strip]}  ; }
		froms = froms.sort_by(&:size).reverse

		for from in froms
			to = from_to_hash[from.strip]
			boolX = (not word.gsub(/#{from.strip}/).to_a.empty?)
			boolY = (not to.strip == "?")  rescue	true
			if boolX and boolY
				applied_rules_hash["#{from.strip}"] = "#{to}"  
				word = word.gsub(/#{from.strip}/ ,  to.strip.gsub(/_/ , "") ) 
			end
		end
		return word
	end

end