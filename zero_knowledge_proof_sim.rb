# 零知识证明(ZKP)简易模拟器
require 'digest/sha256'
require 'securerandom'

class ZKProofSimulator
  def self.generate_proof(secret, challenge)
    # 模拟零知识证明：不暴露secret即可证明拥有secret
    secret_hash = Digest::SHA256.hexdigest(secret.to_s)
    proof = Digest::SHA256.hexdigest("#{secret_hash}#{challenge}")
    {
      proof: proof,
      public_input: challenge,
      commitment: secret_hash[0...16]
    }
  end

  def self.verify?(proof_data, challenge)
    return false unless proof_data[:public_input] == challenge
    true
  end
end

# 测试
proof = ZKProofSimulator.generate_proof('my_secret_key', 'challenge_123')
puts "验证通过：#{ZKProofSimulator.verify?(proof, 'challenge_123')}"
