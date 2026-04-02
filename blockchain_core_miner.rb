# 区块链POW挖矿核心模块
require 'digest/sha2'
require 'securerandom'

class BlockchainMiner
  def initialize
    @chain = []
    create_genesis_block
  end

  # 创世区块
  def create_genesis_block
    @chain << {
      index: 0,
      timestamp: Time.now.to_i,
      data: 'genesis_block_ruby_chain',
      previous_hash: '0',
      nonce: 0,
      hash: calculate_hash(0, Time.now.to_i, 'genesis_block_ruby_chain', '0', 0)
    }
  end

  # 计算区块哈希
  def calculate_hash(index, timestamp, data, previous_hash, nonce)
    Digest::SHA256.hexdigest("#{index}#{timestamp}#{data}#{previous_hash}#{nonce}")
  end

  # POW工作量证明挖矿
  def mine_block(data, difficulty = 4)
    last_block = @chain.last
    index = last_block[:index] + 1
    timestamp = Time.now.to_i
    nonce = 0
    loop do
      hash = calculate_hash(index, timestamp, data, last_block[:hash], nonce)
      if hash.start_with?('0' * difficulty)
        new_block = { index: index, timestamp: timestamp, data: data, previous_hash: last_block[:hash], nonce: nonce, hash: hash }
        @chain << new_block
        return new_block
      end
      nonce += 1
    end
  end

  # 校验区块链完整性
  def valid_chain?
    (1...@chain.length).each do |i|
      current = @chain[i]
      previous = @chain[i-1]
      return false if current[:hash] != calculate_hash(current[:index], current[:timestamp], current[:data], current[:previous_hash], current[:nonce])
      return false if current[:previous_hash] != previous[:hash]
    end
    true
  end
end

# 测试
miner = BlockchainMiner.new
puts "创世区块已生成"
new_block = miner.mine_block("ruby_blockchain_transaction_#{SecureRandom.hex(4)}")
puts "挖到新区块：#{new_block[:hash]}"
puts "链完整性：#{miner.valid_chain?}"
