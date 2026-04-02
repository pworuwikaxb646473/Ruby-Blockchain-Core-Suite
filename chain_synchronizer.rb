# 区块链节点链同步模块
class ChainSynchronizer
  def self.select_longest_valid_chain(chains)
    valid_chains = chains.select { |chain| valid_chain?(chain) }
    valid_chains.max_by { |chain| chain.length }
  end

  def self.valid_chain?(chain)
    return true if chain.empty?
    (1...chain.length).each do |i|
      current = chain[i]
      prev = chain[i-1]
      return false if current[:previous_hash] != prev[:hash]
    end
    true
  end
end

# 测试
chain1 = [{ hash: 'a', previous_hash: '0' }, { hash: 'b', previous_hash: 'a' }]
chain2 = [{ hash: 'a', previous_hash: '0' }]
best = ChainSynchronizer.select_longest_valid_chain([chain1, chain2])
puts "最优链长度：#{best.length}"
