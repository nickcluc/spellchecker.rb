require "pry"

$possibilities = []
$corrected_sentence_array = []
$alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('')
$dictionary = []

dictionary_hash = Hash.new(0)
words = []
File.read('lotsowords.txt').downcase.scan(/[\w']+/).each{|word| dictionary_hash[word] += 1}
dictionary_hash.to_a.sort_by!{|key, value | value}.reverse.each do |word_count|
	$dictionary << word_count[0]
end



def swap_letter(input)
	i=0
	original = input.to_sym
	corrected = ''
	until $dictionary.include?(input) || i > (input.length - 2)
		input[i], input[i+1] = input[i+1], input[i]
		if $dictionary.include?(input)
			corrected = input
			return corrected
		else
			i+=1
			input = original.to_s
		end
	end
end

def add_letter(input)
	original = input.to_sym
	i=0
	new_word = ''
	until i > input.length
		for letter in $alphabet
			input = input.split('')
			input.insert(i, letter)
			new_word = input.join('')
			if $dictionary.include?(new_word)
				input = new_word
				return new_word
			else
				input = original.to_s
			end
		end
		i+=1
	end
end

def remove_letter(input)
	original = input.to_sym
	i=0
	new_word = ''
	until input == new_word do
		input = input.split('')
		input.delete_at(i)
		new_word = input.join('')
		if $dictionary.include?(new_word)
			return new_word
			input = new_word
		elsif i > input.length
			break
		else
			input = original.to_s
			i+=1
		end
	end
end

def correct(input)
	input.split(' ').each do |word|
		if $dictionary.include?(word)
			$corrected_sentence_array << word
		else
			added = add_letter(word)
			removed = remove_letter(word)
			swapped = swap_letter(word)
			if $dictionary.include?(added)
				$corrected_sentence_array << added
			elsif $dictionary.include?(swapped)
				$corrected_sentence_array << swapped
			elsif $dictionary.include?(removed)
				$corrected_sentence_array << removed
			else
				$corrected_sentence_array << ("*" + word)
			end
		end
	end
end

input = ARGV.join(" ")
correct(input)
p $corrected_sentence_array.join(' ')
