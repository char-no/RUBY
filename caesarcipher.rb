class CaeserCiph

    def encrypt(message, k)
        puts "This is the input: #{message}."
        alphabet = "abcdefghijklmnopqrstuvwxyz"
        x = message.length
        puts "This is the message length: #{x}"
        for i in 0..x-1

                originalindex = alphabet.index(message[i])
                puts "This is the original index: #{originalindex}"
                newind = originalindex + k
                puts "This is the new index: #{newind} without wraparound."
                    if newind > 25
                        newind = newind - 26
                        puts "This is the new index with wraparound: #{newind}"
                    end
                message[i] = alphabet[newind]
        end
        puts ' '
        puts "This is the encoded message output: #{message}, and the code number: #{k}."
    end
        
    def decrypt (encoded, k)
        alphabet = "abcdefghijklmnopqrstuvwxyz"
        puts ' '
        puts "This is the encoded message input: #{encoded} and the code number: #{k}."
        for i in 0..encoded.length-1
            encodedindex = alphabet.index(encoded[i])
            newind = (encodedindex - k)
            if newind < 0 
                newind = 26 + newind                
            end
            encoded[i] = alphabet[newind]
        end
        puts "This is the decoded message: #{encoded}."
    end
end

puts "Enter the string to be encoded:"
mssg = gets.chomp

puts "Good, now enter the number for the Caeser Cipher: "
num = gets.chomp.to_i

havoc = CaeserCiph.new

puts "\n===============
 ENCODING TIME
===============\n"

havoc.encrypt(mssg, num)

puts "===============
 DECODING TIME
==============="
havoc.decrypt(mssg, num)
