# 默克尔树构建器（区块链区块交易校验）
require 'digest/sha256'

class MerkleTree
  def initialize(transactions)
    @transactions = transactions
    @root = build_root
  end

  def root_hash
    @root
  end

  private

  def build_root
    return '' if @transactions.empty?
    hashes = @transactions.map { |tx| Digest::SHA256.hexdigest(tx.to_s) }
    while hashes.size > 1
      hashes = hashes.each_slice(2).map do |a, b|
        b ? Digest::SHA256.hexdigest(a + b) : a
      end
    end
    hashes.first
  end
end

# 测试
txs = ['tx1', 'tx2', 'tx3', 'tx4']
tree = MerkleTree.new(txs)
puts "默克尔根：#{tree.root_hash}"
