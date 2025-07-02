require_relative "bible_reader/genesis"
require_relative "bible_reader/exodo"
require_relative "bible_reader/levitico"
require_relative "bible_reader/numeros"
require_relative "bible_reader/deuteronomio"
require_relative "bible_reader/mateo"

module BibleReader
  extend self

  def books
    { "genesis" => Genesis.new,
      "exodo" => Exodo.new,
      "levitico" => Levitico.new,
      "numeros" => Numeros.new,
      "deuteronomio" => Deuteronomio.new,
      "mateo" => Mateo.new
    }
  end

  def book_names
    [
      "genesis",
      "exodo",
      "levitico",
      "numeros",
      "deuteronomio",
      "mateo"
    ]
  end

  def find_chapter(book, chapter)
      bible_book = open_web_file(book)[1]
      default = "000:001"
      if chapter.chars.count == 1
          chapter_start = default.sub("0:", "#{chapter}:")
          chapter_finish = chapter_start.dup
          chapter_finish = chapter_start.sub("#{chapter}:", "#{(chapter.to_i + 1).to_s}:")
          if chapter_finish.chars.count > 7
              chapter_finish[0] = ''
          end
      elsif chapter.chars.count == 2
          chapter_start = default.sub("00:", "#{chapter}:")
          chapter_finish = chapter_start.dup
          chapter_finish = chapter_start.sub("#{chapter}:", "#{(chapter.to_i + 1).to_s}:")
      end
      selection = find_bible_selection(bible_book, chapter_start, chapter_finish)
      puts selection.class
      transform_web_format_to_bible_verses(selection)
      puts wrap(selection, 75)
      close_file(open_web_file(book)[0])
  end

  def find(word, book_name)
      puts "\nResultados de búsqueda de '#{word}' en el libro de #{book_name}: "
      # word_to_regex = Regexp.new word
      file = File.foreach("#{book_name.downcase}_web.txt") do |line|
          if line.include? word
              puts line
          end
      end
  end

  def chapter_range_and_topics(topics_names)
      topics_chapter_range = (1..topics_names[topics_chapter_index].count)   #get range for user display
      topics_chapter_topics = topics_names[topics_chapter_index]
      return topics_chapter_range, topics_chapter_topics
  end

  def display_one_chapter_menu(topics_chapter_str)
      topics_chapter_index = (topics_chapter_str.to_i) - 1                    #change to use for index
      topics_chapter_range = chapter_range_and_topics(topics_names[0])   #get range for user display
      topics_chapter_topics = chapter_range_and_topics(topics_names[1])             #get specific topics for user display
      puts "\nChapter #{topics_chapter_str} topics menu:"
      topics_chapter_range.zip(topics_chapter_topics).each do |(topics_chapter_range, topics_chapter_topics)|
          puts "#{topics_chapter_range}. #{topics_chapter_topics}"
      end
  end

  def find_range(book, start_request, finish_request)
      start = transform_bible_verses_to_web_format(start_request)
      finish = transform_bible_verses_to_web_format(finish_request)
      bible_book = open_web_file(book)[1]
      puts "\n#{book.capitalize} #{start_request} - #{finish_request}: "
      # range = find_bible_selection(bible_book, start, finish)
      range = find_selection_and_remove_verses(bible_book, start, finish)
      puts wrap(range, 75)
      close_file(open_web_file(book)[0])
  end

  def find_one_verse(book, start_request)
    verse_request_web_format = transform_bible_verses_to_web_format(start_request)
    next_verse = increase_verse_by_one(verse_request_web_format, 6)
    start = transform_bible_verses_to_web_format(start_request)
    finish = transform_bible_verses_to_web_format(next_verse)
    bible_book = open_web_file(book)[1]
    puts "\n#{book.capitalize} #{start_request} "
    range = find_selection_and_remove_verses(bible_book, start, finish)
    close_file(open_web_file(book)[0])
    range
  end

    protected

      # def wrap(s, width=78)
      #     s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
      # end

      # def change_to_symbol(num, txt)
      #     num_sym = "chapter_#{num}".to_sym
      #     txt_sym_name = "#{txt.downcase.tr(" ", "_")}_name".to_sym
      #     txt_sym_begin = "#{txt.downcase.tr(" ", "_")}_begin".to_sym
      #     txt_sym_end = "#{txt.downcase.tr(" ", "_")}_end".to_sym
      #     txt_sym_verses = "#{txt.downcase.tr(" ", "_")}_verses".to_sym
      #     return num_sym, txt_sym_name, txt_sym_begin, txt_sym_end, txt_sym_verses
      # end

      def increase_verse_by_one(verse_request, index)
          #duplicate verse request
          next_verse = verse_request.dup
          #increase verse
          increase_next_verse = next_verse[index].to_i + 1
          next_verse[index] = increase_next_verse.to_s
          return next_verse
      end

      def find_bible_selection(bible_book, start, finish)
          #change file to array
          bible_book_arr = bible_book.split
          #find indexes of verse positions
          before = bible_book_arr.find_index(start)
          after = bible_book_arr.find_index(finish)
          #convert selection from array to string for user
          selection = bible_book_arr[(before)..(after - 1)].join(" ")
          return selection
      end

      def close_file(file)
          file.close()
      end

      def open_web_file(book)
          #open file
          file = File.open(Rails.root.join("lib", "bible_text", "#{book}_web.txt"))
          #read file
          bible_book = file.read
          return file, bible_book
      end

      def find_selection_and_remove_verses(bible_book, start, finish)
          output = find_bible_selection(bible_book, start, finish)
          #select range in verses
          start_range = start.slice start[5] + start[6]
          finish_range = finish.slice finish[5] + finish[6]
          range_verses = ((start_range.to_i)..(finish_range.to_i))
          #use original begin verse and convert it to array for processing
          start_arr = start.split('')
          #remove verses from text
          range_verses.each do |i|
              if i.digits.count == 1
                  i_digits_arr = []
                  i_digits_arr << i.digits
                  start_arr[6] =  i_digits_arr[0][0]
                  start_arr.join('')
                  output.slice! (start_arr.join(''))
              elsif i.digits.count == 2
                  i_digits_arr = []
                  i_digits_arr << i.digits
                  start_arr[5] = i_digits_arr[0][1]
                  start_arr[6] =  i_digits_arr[0][0]
                  start_arr.join('')
                  output.slice! (start_arr.join(''))
              end
          end
          return output
      end

      def transform_bible_verses_to_web_format(verse_request)
          #transform user verse request to web format:
          verse_request_web_format = verse_request.dup
          verse_request_web_format.chars.each do |i|
              if (verse_request_web_format.chars.find_index(":") == 1) and (verse_request_web_format.chars.count == 3) #ex '1:1'
                  verse_request_web_format = verse_request_web_format.chars.insert(0, "00").join('')
                  verse_request_web_format = verse_request_web_format.chars.insert(4, "00").join('')
              elsif (verse_request_web_format.chars.find_index(":") == 1) and (verse_request_web_format.chars.count == 4) #ex '1:11'
                  verse_request_web_format = verse_request_web_format.chars.insert(0, "00").join('')
                  verse_request_web_format = verse_request_web_format.chars.insert(4, "0").join('')
                  puts verse_request_web_format
                  puts verse_request_web_format.class
              elsif (verse_request_web_format.chars.find_index(":") == 2) and (verse_request_web_format.chars.count == 4) #ex '11:1'
                  verse_request_web_format = verse_request_web_format.chars.insert(0, "0").join('')
                  verse_request_web_format = verse_request_web_format.chars.insert(4, "00").join('')
              elsif (verse_request_web_format.chars.find_index(":") == 2) and (verse_request_web_format.chars.count == 5) #ex '11:11'
                  verse_request_web_format = verse_request_web_format.chars.insert(0, "0").join('')
                  verse_request_web_format = verse_request_web_format.chars.insert(4, "0").join('')
              end
          end
          verse_request_web_format
      end

      def transform_web_format_to_bible_verses(selection)
        selection.gsub(/[00]/, "")
        selection
      end
end
