class Poker
  SORT = {
    'A' => 1,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '0' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13
    }
  VALUE = {
    'A' => 1,
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '0' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10
    }
  COLOR = {
    'S' => 4,
    'H' => 3,
    'C' => 2,
    'D' => 1
    }
  attr_reader :hand
  attr_reader :dealed_hand

  def initialize(denotation)
    @hand = denotation
    @dealed_hand = denotation.gsub('10', '0').split('')
  end

  def record_init(record)
    # 处理获取到的发牌记录,结果eg: {"C_10"=>9, "D_8"=>7, "D_10"=>9, "S_8"=>7, "D_3"=>2}
    # 'C_10'中'C'记录的是花色, spade(S) > heart(H) > club(C) > diamond(D), 数字根据PokerGame::SORT记录顺序大小
    j = ''
    record_hash = {}
    record.each do |arr|
      if ['S', 'H', 'C', 'D'].include?(arr)
        j = arr
        next
      end
      h_key = j + '_' + Poker::SORT[arr].to_s
      record_hash[h_key] = Poker::VALUE[arr]
    end
    return record_hash
  end

  def highest_rank(records)
    records.keys.map {|k| k.split("_").last.to_i}.max
  end

  def highest_color(records, max_num)
    records.keys.select {|item| item.include?(max_num.to_s)}.map {|k| Poker::COLOR[k[0]]}.max
  end

  def get_score(record_list)
    # 获取分数的思路是如果三张牌之和能被10整除
    # 余下的两张牌之和除以10的余数等于五张牌之和除以10的余数
    values = record_list.values
    remainder = (values.inject(:+))%10
    count = values.count
    [*0..(count-2)].each do |i|
      [*(i+1)..(count-1)].each do |j|
        sum = values[i] + values[j]
        if sum%10 == remainder
          return sum > 10 ? (sum -10) : sum
        end
      end
      i += 1
    end
    return 0 # 不满足任意三张牌之和为10的倍数的情况
  end

  def self.compare_one(leon_poker, judy_poker)
    # record_init方法处理记录,返回eg: {"C_10"=>9, "D_8"=>7, "D_10"=>9, "S_8"=>7, "D_3"=>2}
    leon_init = leon_poker.record_init(leon_poker.dealed_hand)
    judy_init = judy_poker.record_init(judy_poker.dealed_hand)
    if leon_init.count == 5 && judy_init.count == 5  # 去除不合规的记录
      leon_score = leon_poker.get_score(leon_init) # 获取分数
      judy_score = judy_poker.get_score(judy_init)
      if leon_score != judy_score # 分数不相等情况直接比大小
        tag = leon_score > judy_score
      else
        # 分数相等的情况,先比较highest_rank
        leon_max = leon_poker.highest_rank(leon_init)
        judy_max = judy_poker.highest_rank(judy_init)
        if leon_max == judy_max  # highest_rank相等的情况,在比较花色
          leon_color_max = leon_poker.highest_color(leon_init, leon_max)
          judy_color_max = judy_poker.highest_color(judy_init, judy_max)
          tag = leon_color_max > judy_color_max
        else
          tag =  leon_max > judy_max
        end
      end
      winner = tag ? 'leon' : 'judy' # 记录获胜者
      return ["#{winner}", "#{leon_poker.hand};#{judy_poker.hand}"]
    end
  end

  def self.compare
    win_record = {'leon' => [], 'judy' => []}
    File.readlines("LJ-poker.txt").each do |line| # LJ-poker.txt为原始数据
      record = line.rstrip!.split(';')
      leon_poker = Poker.new(record.first)
      judy_poker = Poker.new(record.last)
      reslut = Poker.compare_one(leon_poker, judy_poker)
      next if reslut.nil?
      winner = reslut[0]
      win_record[winner] << reslut[-1]
    end
    win_record.each do |key, value|
      File.open("#{key}.txt", 'w+') do |file|
        value.each do |line|
          file.puts "#{line}"
        end
        file.close
      end
    end
    return {'leon' => win_record['leon'].count, 'judy' => win_record['judy'].count}
  end
  
end

Poker.compare  # 运行程序