note    
    description: "Esempio base per iniziare" 
    author: "Mattia Monga"

class 
    HELLO
 
create
    make
 
feature -- sezione: puo` contenere molte feature
	make
		local
		  s: STRING
		do
			   s := "Hello"
            print (s + " World! (con print)%N") 
            io.put_string ("Hello World!"); io.put_new_line
		end
end
