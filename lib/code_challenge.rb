# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'pp'

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
                     # string manipulation is simple in Ruby & Python
        rescue StandardError => msg
          puts msg
        rescue Exception => msg
          puts msg
        end
        
        return -1 
      end
     
      def check_bounds(rawinput)        
        unless NETMASK_LOOKUP_TABLE.include?(rawinput)
            raise OutofBoundsError 
        end
      end     
    
      def find_mac_address(filename)
        matches = []
        regex_pattern = /[\s]+[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}[\s]+/
        i=0
        begin
          File.open(filename).each do |line|
            found = line.scan(regex_pattern)
            found.each do |f|
              matches << {filename.split('/')[-1] => {"line #{i}" => f}} if found
            end
            i=i+1
          end
        rescue Exception => msg
          puts msg
        end
        return matches
      end
      
      def explodereport(rawinput)
        dumper = {}
        rawinput.each do |line|
            exploder_helper(line.split('|'), 0, dumper) 
        end
        # use Ruby pretty print, for desired print
        pp(dumper.sort) 

        return dumper  
      end

      def exploder_helper(lst, index, hsh)
        
        if index < (lst.length() -1) then 
          if hsh.has_key?(lst[index]) then
              hsh[lst[index]] = exploder_helper(lst, index+1, 
                                                     hsh[lst[index]])
              return hsh
          else
              hsh[lst[index]] = exploder_helper(lst, index+1, {})
              return hsh 
          end
        else
            return lst[index] 
        end
       end

    # end of class
    end
    
    class OutofBoundsError < StandardError # custom error
      def initialize(msg="INVALID Netmask!")
        super(msg)
      end
    end
    
    
end
