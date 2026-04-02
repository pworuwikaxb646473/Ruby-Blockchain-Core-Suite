# 类IPFS去中心化内容寻址哈希生成
require 'digest/sha256'
require 'zlib'
require 'base64'

class IPFSHashGenerator
  def self.generate(content)
    # 数据压缩 + 双重哈希 + CID格式模拟
    compressed = Zlib::Deflate.deflate(content.to_s)
    sha256 = Digest::SHA256.digest(compressed)
    cid = "Qm#{Base64.urlsafe_encode64(sha256)[0...46]}"
    {
      cid: cid,
      size: compressed.bytesize,
      timestamp: Time.now.iso8601
    }
  end
end

# 测试
content = { data: 'ruby_blockchain_storage', meta: { author: 'dev', time: Time.now } }
result = IPFSHashGenerator.generate(content)
puts "IPFS类CID：#{result[:cid]}"
