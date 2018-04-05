# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.


class CustomDict
  attr_reader :history

  def initialize(params=nil)
    @history = {}
    params and params.each do |k,v| 
      instance_variable_set("@#{k}",v) unless v.nil?
    end      
  end

  def get(key)
    return instance_variable_get("@#{key}")
  end

  def add(params=nil)
    params and params.each do |k,v| 
      instance_variable_set("@#{k}",v) unless v.nil?
    end     
  end


  def delete(key)
    remove_instance_variable("@#{key}")  
    @history[key] = 'DELETE '+key
  end

  def modify(params=nil)
    params and params.each do |k,v| 
      instance_variable_set("@#{k}",v) unless v.nil?
      @history[k] = 'MODIFY '+k+' = '+v
    end    
  end

  def deltas()
    @history.each do |key, value|
      puts value
    end

    return @history
  end
end
