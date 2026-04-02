# POS权益证明共识模块
require 'securerandom'

class POSConsensus
  def initialize
    @validators = {} # 地址 => 质押金额
  end

  # 节点质押
  def stake(address, amount)
    return false if amount <= 0
    @validators[address] = (@validators[address] || 0) + amount
    true
  end

  # 按权益权重选举出块节点
  def select_block_proposer
    total_stake = @validators.values.sum
    return nil if total_stake.zero?

    rand_val = rand(total_stake)
    current = 0
    @validators.each do |addr, stake|
      current += stake
      return addr if current > rand_val
    end
  end

  def validators_list
    @validators.dup
  end
end

# 测试
pos = POSConsensus.new
pos.stake('node01', 100)
pos.stake('node02', 300)
proposer = pos.select_block_proposer
puts "本轮出块节点：#{proposer}"
