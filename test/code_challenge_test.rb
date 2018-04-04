# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'code_challenge'

class CodeChallengeTest < Test::Unit::TestCase
  def test_cidr_bits_pass
    rawinput = "255.255.252.0"
    result = CodeChallenge.netmask_to_bits(rawinput)
    expected = 22
    assert_equal(expected, result)
  end
  
  def test_cidr_bits_fail_ValueError
        rawinput = "255.1.2.x"
        result = CodeChallenge.netmask_to_bits(rawinput)
        expected = -1
        assert_equal(expected, result)
  end
end
