require './poker.rb'
require 'test/unit'

class PokerTest < Test::Unit::TestCase 
  def setup
    # 初始化leno和judy的值
    @leno_poker = Poker.new('C9D7D9S7D2')
    @judy_poker = Poker.new('HAC5S8D8C10')
    # 处理leno和judy的牌,结果eg:{"C_9"=>9, "D_7"=>7, "D_9"=>9, "S_7"=>7, "D_2"=>2}
    @leno_record_init = @leno_poker.record_init(@leno_poker.dealed_hand)
    @judy_record_init = @judy_poker.record_init(@judy_poker.dealed_hand)
    # 获取leno和judy的分数,结果在  0 =< 结果 =< 10
    @leno_get_score = @leno_poker.get_score(@leno_record_init)
    @judy_get_score = @judy_poker.get_score(@judy_record_init)
    # 获取leno和judy的最大的牌,结果参考Poker::SORT
    @leno_highest_rank = @leno_poker.highest_rank(@leno_record_init)
    @judy_highest_rank = @judy_poker.highest_rank(@judy_record_init)
    # 获取最大牌的最大花色,结果参考Poker::Color
    @leno_highest_color = @leno_poker.highest_color(@leno_record_init, @leno_highest_rank)
    @judy_highest_color = @judy_poker.highest_color(@judy_record_init, @judy_highest_rank)
  end

  def test_initialize
    # 测试.hand的值是否正确
    assert_equal('C9D7D9S7D2', @leno_poker.hand, 'hand is not correct!')
    assert_equal('HAC5S8D8C10', @judy_poker.hand, 'hand is not correct!')
    # 测试.dealed_hand的值是否正确
    assert_equal(["C", "9", "D", "7", "D", "9", "S", "7", "D", "2"], 
                  @leno_poker.dealed_hand, 'leno dealed_hand is not correct!')
    assert_equal(["H", "A", "C", "5", "S", "8", "D", "8", "C", "0"], 
                  @judy_poker.dealed_hand, 'judy dealed_hand is not correct!')
  end

  def test_record_init
    # 测试leno的record_init
    assert_equal({"C_9"=>9, "D_7"=>7, "D_9"=>9, "S_7"=>7, "D_2"=>2}, 
                  @leno_record_init, 'judy record id not correct!')
    # 测试judy的record_init
    assert_equal({"H_1"=>1, "C_5"=>5, "S_8"=>8, "D_8"=>8, "C_10"=>10}, 
                  @judy_record_init, 'judy record id not correct!')
  end

  def test_get_score
    # 测试leno的score
    assert_equal(4, @leno_get_score, "leno score is not correct!")
    # 测试judy的score
    assert_equal(0, @judy_get_score, "judy score is not correct!")
  end

  def test_highest_rank
    # 测试leno的最大牌值,牌的值为题目表格所提供,参考Poker::SORT
    assert_equal(9, @leno_highest_rank, "leno highest_rank is not correct!")
    # 测试judy的最大牌值
    assert_equal(10, @judy_highest_rank, "judy highest_rank is not correct!")
  end

  def test_highest_color
    # 测试leno的最大牌值的花色,花色的值为spade(S) > heart(H) > club(C) > diamond(D)
    # 设置S的值为4, 参考Poker::COLOR
    assert_equal(2, @leno_highest_color, "leno highest_color is not correct!")
    # 测试judy的最大牌值的花色
    assert_equal(2, @judy_highest_color, "judy highest_color is not correct!")
  end

  def test_compare_one
    # 比较setup方法里面默认的leon和judy的胜负
    assert_equal('leon', Poker.compare_one(@leno_poker, @judy_poker), "compare result wrong")
    # 提供额外两组测试数据
    assert_equal('judy', Poker.compare_one(Poker.new('C4C9H4H7CK'), Poker.new('C3H6D3S9D8')), "compare result wrong")
    assert_equal('judy', Poker.compare_one(Poker.new('C6D6D4HAS6'), Poker.new('DJS5S3C2S9')), "compare result wrong")
    # leno的记录有问题是,返回nil,结果不会记录这一条
    assert_nil(Poker.compare_one(Poker.new('D4C5D3C'), Poker.new('D8H9SQD5S4')), "compare result wrong")
    # judy的记录有问题
    assert_nil(Poker.compare_one(Poker.new('S10CKC2D5C3'), Poker.new('HKDQSJDA')), "compare result wrong")
    # leno和judy的记录都有问题
    assert_nil(Poker.compare_one(Poker.new('H2S7S8S4'), Poker.new('HKC7D10S3')), "compare result wrong")
  end

  def test_compare
    assert_equal({'leon'=>1365, 'judy'=>1359}, Poker.compare, "finnal result wrong")
  end
end