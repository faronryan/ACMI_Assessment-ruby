# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

# RFC 1878 - https://tools.ietf.org/html/rfc1878
NETMASK_LOOKUP_TABLE = ["128.0.0.0","192.0.0.0","224.0.0.0","240.0.0.0",
                        "248.0.0.0","252.0.0.0","254.0.0.0","255.0.0.0",
                        "255.128.0.0","255.192.0.0","255.224.0.0",
                        "255.240.0.0","255.248.0.0","255.252.0.0","255.254.0.0",
                        "255.255.0.0","255.255.128.0","255.255.192.0",
                        "255.255.224.0","255.255.240.0","255.255.248.0",
                        "255.255.252.0","255.255.254.0","255.255.255.0",
                        "255.255.255.128","255.255.255.192","255.255.255.224",
                        "255.255.255.240","255.255.255.248","255.255.255.252",
                        "255.255.255.254","255.255.255.255"]

module CodeChallenge
    class << self
      def initialize(name)
        print name
      end
      
      def netmask_to_bits(rawinput)
        begin
          sum = 0
          arry = rawinput.split('.').each { |n| n.to_i(2) } 
          arry = arry.collect{|c| "%08b" % c}.inject(:+)
          check_bounds(rawinput)
          arry.split('').each do |x|
            sum += x.to_i 
          end
          
          return sum # could have used the 1-base index!
                     # string manipulation is easy in Ruby & Python
        rescue StandardError => msg
          puts msg
          return -1
        end
        
        return -1 # should never reach here
      end
     
      def check_bounds(rawinput)        
        unless NETMASK_LOOKUP_TABLE.include?(rawinput)
            raise OutofBoundsError 
        end
      end     
      
    end
    
    class OutofBoundsError < StandardError # custom error
      def initialize(msg="INVALID Netmask!")
        super(msg)
      end
    end
end
