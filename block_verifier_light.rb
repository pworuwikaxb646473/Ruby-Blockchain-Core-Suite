# 区块链轻节点区块校验工具
require 'digest/sha256'

class LightBlockVerifier
  def self.valid_block?(block, previous_block_hash, difficulty = 4)
    # 校验区块哈希规则
    return false unless block[:hash].start_with?('0' * difficulty)
    return false if block[:previous_hash] != previous_block_hash

    # 重新计算哈希校验
    computed = Digest::SHA256.hexdigest(
      "#{block[:index]}#{block[:timestamp]}#{block[:data]}#{block[:previous_hash]}#{block[:nonce]}"
    )
    computed == block[:hash]
  end
end

# 测试
test_block = {
  index: 1, timestamp: Time.now.to_i, data: 'test',
  previous_hash: '0000abc', nonce: 12345,
  hash: '0000' + Digest::SHA256.hexdigest('12345')
}
puts "区块有效：#{LightBlockVerifier.valid_block?(test_block, '0000abc')}"
