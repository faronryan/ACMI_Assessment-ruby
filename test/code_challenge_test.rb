# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'code_challenge'
require 'custom_dict'

class CodeChallengeTest < Test::Unit::TestCase
  def test_cidr_bits_pass
    rawinput = "255.255.252.0"
    result = CodeChallenge.netmask_to_bits(rawinput)
    expected = 22
    assert_equal(expected, result)
  end
  
  def test_cidr_bits_fail_value_error
        rawinput = "255.1.2.3"
        result = CodeChallenge.netmask_to_bits(rawinput)
        expected = -1
        assert_equal(expected, result)
  end
  
  def test_find_mac_address
    folder = "../inputs"
    files = Dir.glob("#{folder}/**/*")
    files.each do |file|
      results = CodeChallenge.find_mac_address(file)
      expected = 7
      assert_equal(expected, results.length)
    end
  end
  
  def test_nested_hash_constructor
    rawinput = ['app1|server1|uptime|5', 
                    'app1|server1|loadavg|0.01 0.02 0.03',
                    'app1|server1|conn1|state|up', 
                    'app1|server2|uptime|10', 
                    'app1|server2|loadavg|0.11 0.22 0.33', 
                    'app1|server2|conn1|state|down', 
                    'app1|running|true', ]
    result = CodeChallenge.explodereport(rawinput)
    expected = {'app1' => {'running' => 'true', 
                         'server1' => {'uptime' => '5', 
                                     'loadavg' => '0.01 0.02 0.03', 
                                     'conn1' => {'state' => 'up'}}, 
                         'server2' => {'uptime' => '10', 
                                     'loadavg' => '0.11 0.22 0.33', 
                                     'conn1' => {'state' => 'down'}}}}
    assert_equal(expected, result) 
  end
  
  def test_custom_dict_constructor_init()
    
    result = CustomDict.new('deer' => 'park', 'foo' => 'bar', 
                                      'this' => 'that')
    expected = 'that'
    assert_equal(expected, result.get('this')) 
    expected = 'park'
    assert_equal(expected, result.get('deer')) 

    expected = 'bar'
    assert_equal(expected, result.get('foo'))
  end
  
  def test_custom_dict_modifiers()
    result = CustomDict.new('deer' => 'park', 'foo' => 'bar', 
                                  'this' => 'that')
    result.delete('this'); 
    result.add('gnu' => 'linux'); 
    result.modify('gnu' => 'not unix'); 
    print result.get('gnu') 
    result.modify('deer' => 'venison'); 
    result.modify('gnu' => 'emacs'); 
    result.deltas; 
    expected = 'emacs'
    assert_equal(expected, result.get('gnu'))
    
    expected = 'bar'
    assert_equal(expected, result.get('foo'))
    
    res = result.deltas()
    expected = {'this' => 'DELETE this', 'deer' => 'MODIFY deer = venison', 
                'gnu' => 'MODIFY gnu = emacs'}
    assert_equal(expected, res)
  end
end
