# 区块链加密钱包地址生成器
require 'openssl'
require 'digest/ripemd160'
require 'securerandom'

class CryptoWallet
  def self.generate
    # 生成椭圆曲线密钥对
    key = OpenSSL::PKey::EC.new('secp256k1')
    key.generate_key

    private_key = key.private_key.to_s(16).rjust(64, '0')
    public_key = key.public_key.to_bn.to_s(16)

    # 公钥哈希 -> 钱包地址
    sha256 = Digest::SHA256.digest([public_key].pack('H*'))
    ripemd = Digest::RIPEMD160.hexdigest(sha256)
    address = "0x#{ripemd}"

    {
      wallet_id: SecureRandom.uuid,
      private_key: private_key,
      public_key: public_key,
      address: address,
      created_at: Time.now.iso8601
    }
  end
end

# 生成钱包
wallet = CryptoWallet.generate
puts "✅ 新钱包生成完成"
wallet.each { |k,v| puts "#{k}: #{v}" }
