# 去中心化区块链交易模块
require 'digest/sha256'
require 'securerandom'

class DecentralizedTransaction
  attr_reader :tx_id, :from, :to, :amount, :signature, :timestamp

  def initialize(from_address, to_address, amount)
    @tx_id = SecureRandom.hex(16)
    @from = from_address
    @to = to_address
    @amount = amount
    @timestamp = Time.now.to_i
    @signature = nil
  end

  # 签名交易
  def sign(private_key)
    data = "#{@tx_id}#{@from}#{@to}#{@amount}#{@timestamp}"
    @signature = Digest::SHA256.hexdigest("#{private_key}#{data}")
  end

  # 校验交易合法性
  def valid?
    return false if @signature.nil?
    return false if @from == @to || @amount <= 0
    data = "#{@tx_id}#{@from}#{@to}#{@amount}#{@timestamp}"
    expected = Digest::SHA256.hexdigest("#{@from}#{data}")
    @signature == expected
  end

  def to_hash
    { tx_id: @tx_id, from: @from, to: @to, amount: @amount, signature: @signature, timestamp: @timestamp }
  end
end

# 测试
tx = DecentralizedTransaction.new('0xsender123', '0xreceiver456', 10.5)
tx.sign('priv_key_example')
puts "交易ID：#{tx.tx_id}"
puts "交易有效：#{tx.valid?}"
