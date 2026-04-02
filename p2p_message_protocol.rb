# 区块链P2P节点通信协议
require 'json'
require 'securerandom'

class P2PMessageProtocol
  def self.create_message(type, data, node_id)
    {
      message_id: SecureRandom.uuid,
      node_id: node_id,
      type: type, # new_block / new_tx / sync_chain / peer_info
      data: data,
      timestamp: Time.now.iso8601,
      version: 'ruby-p2p-v1'
    }.to_json
  end

  def self.parse_message(json_str)
    JSON.parse(json_str)
  rescue
    nil
  end
end

# 测试
msg = P2PMessageProtocol.create_message('new_block', { block_id: '0x123' }, 'node-ruby-01')
puts "P2P消息：#{msg}"
