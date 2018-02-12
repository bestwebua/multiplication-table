=begin
Multiplication Table by Vladislav Trotsenko.

During the repetition of multiplication table with my son Jacob
I have found the main idea for this terminal knowledge inspector.
He use it everyday like a game and skill up his knowledge level with a fun :)

No multi language support, ru version only. Sorry :)
=end

#New methods for default classes
class Float
  def to_i_if_whole
    self == to_i ? to_i : self
  end
end

class Integer
  def to_s_min
    divmod(60).map.with_index { |item, index| index.zero? ? item.to_s + ' мин' : item.to_s + ' сек' unless item.zero? }
    .compact.join(' и ')
  end

  def percent_of(total)
    (to_f*100/total.to_f).round(2).to_i_if_whole
  end
end

#Class & methods for selecting and printing top score
class Inverter
  attr_reader :r

  def initialize(r)
    @r = r
  end

  def <=>(other)
    -(@r <=> other.r)
  end
end

def inverter(*args)
  Inverter.new(*args)
end

def top_score(arr)
  top_score = arr.map { |line| line[0...-1].split(', ').map.with_index do |item, index|
    case index
      when 2 then item.to_f.to_i_if_whole
      when 3, 4 then item.to_i
      else item
    end
  end
  }
  .sort_by { |item| [item[2], inverter(item[3])] }.last
    date, name, progress, runtime, errors = top_score
  puts "Лучший результат у игрока #{name}, знает таблицу умножения на #{progress}%. Задание выполнено за #{runtime.to_s_min}."
end

#Main body
log = File.new("#{File.expand_path(File.dirname(__FILE__))}/log.txt", 'a+')
  if File.zero?(log)
    puts "Твой результат прохождения будет первым!"
  else
    scores_list = IO.readlines(log).map { |line| line[0...-1] }
    top_score(scores_list)
  end
puts 'Добро пожаловать! Введи свое имя:'
name = gets.chomp
puts "#{name}, давай повтроим табличку умножения :)"

  questions = runtime = 0
    wrong_answers, right_answers_in_a_row, medals = [], 0, []
      questions_stack = (2..9).to_a.permutation(2).to_a + (2..9).to_a.combination(1).map { |i| i << i.first }
        until questions_stack.empty? do
          questions_stack = questions_stack.shuffle; num1, num2 = questions_stack.pop
            right_answer, answer, question = num1*num2, '', "#{num1} x #{num2}"
              puts "=> #{question} ="
                starttime = Time.now
                  answer = gets.chomp while answer.match(/\D/) || answer == ''
                    if answer.to_i == right_answer
                      time_taken_to_answer = (Time.now-starttime).round
                        runtime+=time_taken_to_answer
                          time_informer = case time_taken_to_answer
                                            when 0..5 then medals << '💎' and "#{name}, отличная скорость! Вы награждаетесь 💎"
                                            when 6..14 then ''
                                            when 15..25 then 'Чтобы получить 💎 попробуй отвечать чуточку быстрее.'
                                            else 'Ты очень долго думаешь над ответом, быстро отвечай и будут нарграды!'
                                          end
                      right_answers_in_a_row+=1
                          informer = case right_answers_in_a_row
                                      when 3 then "#{name}, у тебя отлично выходит!"
                                      when 5 then "Очень хорошо #{name}, так держать!"
                                      when 10, 15, 20, 25 then medals << '🎖' and "#{name}, Вы награждаетесь 🎖"
                                      when 30 then medals << '☺' and "#{name}, я вижу ты знашь таблицу умножения, держи :)"
                                      when 40, 50, 60 then medals << '★' and "#{name}, Вы награждаетесь ★"
                                      else 'Правильно!'
                                    end
                      puts informer + ' ' + time_informer
                    else
                      right_answers_in_a_row = 0
                        questions_stack << [num1, num2]
                        wrong_answers << question unless wrong_answers.include?(question)
                      puts "Ошибка! Правильный ответ: #{right_answer}"
                    end
          questions+=1
        end

        date, errors = Time.now, wrong_answers.size
      progress = (questions-errors).percent_of(questions)
    need_to_learn = wrong_answers.empty? ? nil : wrong_answers.to_s
  scores = [date, name, progress, runtime, errors, need_to_learn].compact.join(', ')
rewards = medals.group_by(&:itself).map { |k,v| "#{k}  : #{v.size}" }.join(', ')

  puts "Ты знаешь таблицу умножения на #{progress}%"
    puts progress == 100 ? "#{name}, ты успешно прошел курс #Таблица умножения#, так держать!" : "#{name}, над этими примерами нужно пработать: #{wrong_answers}"
  puts "Вы заработали #{rewards}" unless medals.size.zero?

File.open(log, 'a+') { |data| data.puts scores }

=begin
#Version 2.0
class Number
  def self.new
    rand(2..9)
  end
end

puts 'Добро пожаловать! Введи свое имя:'
name = gets.chomp
puts "Привет, #{name}! Давай повтроим табличку умножения :)"
  questions = answers = 0
    questions_stack, wrong_answers, right_answers_in_a_row, medals, nums = [], [], 0, '', ''
      until questions == 64 do
        while nums.empty? || questions_stack.include?(nums)
          nums = ['num1', 'num2'].map { |i| Number.new }
        end
        questions_stack << nums
        num1, num2 = nums
          right_answer, answer = num1*num2, ''
            puts "=> #{num1} x #{num2} ="
              answer = gets.chomp while answer.match(/\D/) || answer == ''
                if answer.to_i == right_answer
                  right_answers_in_a_row+=1
                    answers+=1
                      informer = case right_answers_in_a_row
                                  when 5 then 'Очень хорошо, так держать!'
                                  when 10 then "#{name}, у тебя отлично выходит!"
                                  when 15, 20, 25 then medals << '🎖' and "#{name}, Вы награждаетесь медалькой 🎖"
                                  when 30 then "#{name}, я вижу ты знашь таблицу умножения :)"
                                  else 'Правильно!'
                                end
                      puts informer
                else
                  right_answers_in_a_row = 0
                    puts "Ошибка! Правильный ответ: #{right_answer}"
                  wrong_answers << "#{num1} x #{num2}"
                end
        questions+=1
      end
    puts "Вопросов: #{questions}, правильных ответов: #{answers}."
  puts questions == answers ? "#{name}, ты успешно прошел курс #Таблица умножения#, так держать!" : "#{name}, над этими примерами нужно пработать: #{wrong_answers.uniq}"
puts "Вы заработали #{medals}" unless medals.size.zero?

#Version 1.0
class Number
  def self.new
    rand(2..9)
  end
end

puts 'Добро пожаловать! Введи свое имя:'
name = gets.chomp
puts "Привет, #{name}! Давай повтроим табличку умножения :)"
  questions = answers = 0
    wrong_answers, right_answers_in_a_row, medals = [], 0, ''
      until questions == 64 do
        num1, num2 = ['num1', 'num2'].map { |i| Number.new }
          right_answer, answer = num1*num2, ''
            puts "=> #{num1} x #{num2} ="
              answer = gets.chomp while answer.match(/\D/) || answer == ''
                if answer.to_i == right_answer
                  right_answers_in_a_row+=1
                    answers+=1
                      informer = case right_answers_in_a_row
                                  when 5 then 'Очень хорошо, так держать!'
                                  when 10 then "#{name}, у тебя отлично выходит!"
                                  when 15, 20, 25 then medals << '🎖' and "#{name}, Вы награждаетесь медалькой 🎖"
                                  when 30 then "#{name}, я вижу ты знашь таблицу умножения :)"
                                  else 'Правильно!'
                                end
                      puts informer
                else
                  right_answers_in_a_row = 0
                    puts "Ошибка! Правильный ответ: #{right_answer}"
                  wrong_answers << "#{num1} x #{num2}"
                end
        questions+=1
      end
    puts "Вопросов: #{questions}, правильных ответов: #{answers}."
  puts questions == answers ? "#{name}, ты успешно прошел курс #Таблица умножения#, так держать!" : "#{name}, над этими примерами нужно пработать: #{wrong_answers.uniq}"
puts "Вы заработали #{medals}" unless medals.size.zero?
=end
