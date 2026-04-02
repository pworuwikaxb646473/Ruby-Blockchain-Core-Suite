# 极简智能合约VM（区块链合约执行引擎）
class SmartContractVM
  def initialize
    @storage = {} # 合约存储
    @events = []
  end

  # 执行合约指令
  def execute(method, params)
    case method
    when 'transfer' then transfer(params[:from], params[:to], params[:amount])
    when 'balance' then @storage[params[:address]] || 0
    when 'lock' then lock_funds(params[:address], params[:amount])
    else 'invalid_method'
    end
  end

  def events_log
    @events.dup
  end

  private

  def transfer(from, to, amount)
    return false if (@storage[from] || 0) < amount
    @storage[from] = (@storage[from] || 0) - amount
    @storage[to] = (@storage[to] || 0) + amount
    @events << { type: 'transfer', from: from, to: to, amount: amount, time: Time.now }
    true
  end

  def lock_funds(address, amount)
    @storage[address] = (@storage[address] || 0) + amount
    @events << { type: 'lock', address: address, amount: amount }
    true
  end
end

# 测试
vm = SmartContractVM.new
vm.execute('lock', { address: 'user01', amount: 100 })
puts "余额：#{vm.execute('balance', { address: 'user01' })}"
