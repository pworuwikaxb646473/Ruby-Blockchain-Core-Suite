# 简化版ERC20代币合约
require 'securerandom'

class ERC20Token
  attr_reader :name, :symbol, :total_supply
  def initialize(name, symbol, total_supply)
    @name = name
    @symbol = symbol
    @total_supply = total_supply
    @balances = {}
    @balances['owner'] = total_supply
  end

  def transfer(from, to, amount)
    return false if (@balances[from] || 0) < amount || amount <= 0
    @balances[from] -= amount
    @balances[to] = (@balances[to] || 0) + amount
    true
  end

  def balance_of(address)
    @balances[address] || 0
  end
end

# 测试
token = ERC20Token.new('RubyChain', 'RUBY', 1000000)
token.transfer('owner', 'user01', 500)
puts "用户余额：#{token.balance_of('user01')} #{token.symbol}"
